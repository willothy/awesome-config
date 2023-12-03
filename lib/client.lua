--- Credit: https://github.com/kosorin/awesome-rice
--- Modified by: Will Hopkins
local ipairs = ipairs
local math = math
local aclient = require("awful.client")
local alayout = require("awful.layout")
local amresize = require("awful.mouse.resize")
local aplacement = require("awful.placement")
local ascreen = require("awful.screen")
local grectangle = require("gears.geometry").rectangle

local capi = {
  ---@diagnostic disable: undefined-global
  awesome = awesome,
  button = button,
  client = client,
  dbus = dbus,
  drawable = drawable,
  drawin = drawin,
  key = key,
  keygrabber = keygrabber,
  mouse = mouse,
  mousegrabber = mousegrabber,
  root = root,
  screen = screen,
  selection = selection,
  tag = tag,
  window = window,
  ---@diagnostic enable: undefined-global
}

local directions = {
  left = { x = -1, y = 0 },
  right = { x = 1, y = 0 },
  up = { x = 0, y = -1 },
  down = { x = 0, y = 1 },
}

local M = {
  resize_corner_size = 50,
  resize_max_distance = 20,
  floating_move_step = 50,
  tiling_resize_factor = 0.02,
}

---@param client client
---@return boolean|nil
function M.is_floating(client)
  if not client then
    return nil
  end

  if client.floating then
    return true
  end

  local screen = client.screen
  if not screen then
    return nil
  end

  local tag = screen.selected_tag
  if not tag then
    return nil
  end

  return tag.layout == alayout.suit.floating
end

local resize_quadrants = {
  horizontal = {
    [1] = { primary = "top", secondary = "right" },
    [2] = { primary = "top", secondary = "left" },
    [3] = { primary = "bottom", secondary = "left" },
    [4] = { primary = "bottom", secondary = "right" },
  },
  vertical = {
    [1] = { primary = "right", secondary = "top" },
    [2] = { primary = "left", secondary = "top" },
    [3] = { primary = "left", secondary = "bottom" },
    [4] = { primary = "right", secondary = "bottom" },
  },
}

---@param client client
---@param coords point
---@return string
function M.get_resize_corner(client, coords)
  local g = client:geometry()
  g.width = g.width + 2 * client.border_width
  g.height = g.height + 2 * client.border_width

  local horizontal, vertical
  local dx, dy

  local corner_size =
    math.min(M.resize_corner_size, math.min(g.width, g.height) / 2)
  if coords.x <= g.x + corner_size then
    horizontal = "left"
  elseif g.x + g.width - corner_size < coords.x then
    horizontal = "right"
  else
    dx = (coords.x - g.x) - (g.width / 2)
  end

  if coords.y < g.y + corner_size then
    vertical = "top"
  elseif g.y + g.height - corner_size < coords.y then
    vertical = "bottom"
  else
    dy = (coords.y - g.y) - (g.height / 2)
  end

  local corner
  if horizontal and vertical then
    corner = vertical .. "_" .. horizontal
  elseif vertical then
    corner = vertical
  elseif horizontal then
    corner = horizontal
  else
    local x, y, w, h, quadrant
    local q = dy < 0 and (dx < 0 and 2 or 1) or (dx < 0 and 3 or 4)
    if g.width > g.height then
      x, y = dx, dy
      w, h = g.width, g.height
      quadrant = resize_quadrants.horizontal[q]
    else
      x, y = dy, dx
      w, h = g.height, g.width
      quadrant = resize_quadrants.vertical[q]
    end
    corner = 2 * (math.abs(x) - math.abs(y)) <= w - h and quadrant.primary
      or quadrant.secondary
  end
  return corner
end

---@param client client
---@param coords point
---@return number
function M.get_distance(client, coords)
  local x, y

  local g = client:geometry()
  g.width = g.width + 2 * client.border_width
  g.height = g.height + 2 * client.border_width

  if g.x > coords.x then
    x = g.x - coords.x
  elseif g.x + g.width < coords.x then
    x = coords.x - (g.x + g.width)
  end

  if g.y > coords.y then
    y = g.y - coords.y
  elseif g.y + g.height < coords.y then
    y = coords.y - (g.y + g.height)
  end

  local distance
  if x and y then
    distance = math.sqrt(x * x + y * y)
  elseif x then
    distance = x
  elseif y then
    distance = y
  else
    distance = 0
  end
  return distance
end

---@return client?, integer?
function M.find_closest(args)
  args = args or {}
  local clients = args.clients
    or (capi.mouse.screen and capi.mouse.screen.clients)
  if not clients then
    return
  end
  local client_count = clients and #clients or 0
  if client_count == 0 then
    return
  end

  local coords = args.coords or capi.mouse.coords()

  local closest_client
  ---@diagnostic disable-next-line: undefined-field
  local closest_distance = math.maxinteger
  for i = 1, client_count do
    local client = clients[i]
    local distance = M.get_distance(client, coords)
    if distance == 0 then
      closest_client = client
      closest_distance = distance
      break
    end
    if not args.max_distance or distance <= args.max_distance then
      if distance < closest_distance then
        closest_client = client
        closest_distance = distance
      end
    end
  end
  return closest_client, closest_distance
end

---@param client client
---@param direction direction
local function move_to_screen(client, direction)
  local target_screen = client.screen:get_next_in_direction(direction)
  if target_screen then
    client.screen = target_screen
    client:activate({ context = "move_to_screen" })
  end
end

---@param client client
---@param direction direction
local function move_floating(client, direction)
  if not client then
    return
  end

  if
    client.maximized
    or (client.immobilized_horizontal and client.immobilized_vertical)
  then
    move_to_screen(client, direction)
    return
  end

  local rc = directions[direction]
  if not rc then
    return
  end

  client:relative_move(
    client.immobilized_horizontal and 0 or (rc.x * M.floating_move_step),
    client.immobilized_vertical and 0 or (rc.y * M.floating_move_step),
    0,
    0
  )
end

---@param client client
---@param direction direction
local function resize_floating(client, direction)
  if
    not client
    or client.immobilized_horizontal
    or client.immobilized_vertical
  then
    return
  end

  if
    client.maximized
    or (client.immobilized_horizontal and client.immobilized_vertical)
  then
    return
  end

  local rc = directions[direction]
  if not rc then
    return
  end

  client:relative_move(
    0,
    0,
    client.immobilized_horizontal and 0 or (rc.x * M.floating_move_step),
    client.immobilized_vertical and 0 or (rc.y * M.floating_move_step)
  )
end

---@param client client
---@param direction direction
local function move_tiling(client, direction)
  if not client or not client.screen then
    return
  end

  if
    client.maximized
    or (client.immobilized_horizontal and client.immobilized_vertical)
  then
    move_to_screen(client, direction)
    return
  end

  local clients = aclient.tiled(client.screen)
  local geometries = {}
  for i, c in ipairs(clients) do
    geometries[i] = c:geometry()
  end
  local target_client =
    grectangle.get_in_direction(direction, geometries, client:geometry())
  if target_client then
    clients[target_client]:swap(client)
  else
    move_to_screen(client, direction)
  end
end

---@param descriptor unknown
---@param parent_descriptor unknown
---@param resize_factor number
local function resize_descriptor(descriptor, parent_descriptor, resize_factor)
  resize_factor = resize_factor * M.tiling_resize_factor
  if resize_factor == 0 then
    return
  end
  for _, cd in ipairs(parent_descriptor) do
    local sign = cd ~= descriptor and -1 or 1
    cd.factor = math.min(math.max(cd.factor + sign * resize_factor, 0), 1)
  end
end

---@param client client
---@param direction direction
local function resize_tiling(client, direction)
  local screen = client and client.screen and capi.screen[client.screen]
  local tag = screen and screen.selected_tag
  if not tag then
    return
  end
  local layout = tag and tag.layout --[[@as awful.layout]]
  ---@diagnostic disable-next-line: undefined-field
  if not layout.is_tilted then
    return
  end

  ---@diagnostic disable-next-line: undefined-field
  local layout_descriptor = tag.tilted_layout_descriptor
  if not layout_descriptor then
    return
  end

  local rc = directions[direction]
  if not rc then
    return
  end

  local clients = aclient.tiled(screen)
  local column_descriptor, item_descriptor =
    layout_descriptor:find_client(client, clients)

  if column_descriptor then
    resize_descriptor(
      column_descriptor,
      layout_descriptor,
      ---@diagnostic disable-next-line: undefined-field
      layout.is_horizontal and rc.x or -rc.y
    )
  end
  if item_descriptor then
    resize_descriptor(
      item_descriptor,
      column_descriptor,
      ---@diagnostic disable-next-line: undefined-field
      layout.is_horizontal and -rc.y or rc.x
    )
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  tag:emit_signal("property::tilted_layout_descriptor")
end

---@param client client
---@param direction direction
function M.move(client, direction)
  client = client or capi.client.focus
  local old_screen = client.screen

  if M.is_floating(client) then
    move_floating(client, direction)
  else
    move_tiling(client, direction)
  end

  local new_screen = client.screen
  if old_screen ~= new_screen then
    ascreen.focus(new_screen)
  end
end

---@param client client
---@param direction direction
function M.resize(client, direction)
  client = client or capi.client.focus
  if M.is_floating(client) then
    resize_floating(client, direction)
  else
    resize_tiling(client, direction)
  end
end

---@param client? client
---@param direction direction
function M.focus(client, direction)
  local old_client = client or capi.client.focus
  aclient.focus.global_bydirection(direction, old_client)
  local new_client = capi.client.focus
  if new_client and new_client ~= old_client then
    new_client:raise()
  else
    ascreen.focus_bydirection(direction)
  end
end

---@param client client
function M.mouse_move(client)
  if
    not client
    or client.fullscreen
    or client.maximized
    or client.type == "desktop"
    or client.type == "splash"
    or client.type == "dock"
  then
    return
  end

  local mouse_coords = capi.mouse.coords()
  local geometry = client:geometry()
  local bw = client.border_width

  local relative_offset = {
    x = geometry.width < 1 and 0
      or ((mouse_coords.x - geometry.x) / (geometry.width + 2 * bw)),
    y = geometry.height < 1 and 0
      or ((mouse_coords.y - geometry.y) / (geometry.height + 2 * bw)),
  }

  amresize(client, "mouse.move", {
    ---@diagnostic disable-next-line: undefined-field
    placement = aplacement.client_move,
    relative_offset = relative_offset,
  })
end

---@param client? client
function M.mouse_resize(client)
  client = client
    or M.find_closest({
      max_distance = M.resize_max_distance,
    })

  if
    not client
    or client.fullscreen
    or client.maximized
    or (client.immobilized_horizontal and client.immobilized_vertical)
    or client.type == "desktop"
    or client.type == "splash"
    or client.type == "dock"
  then
    return
  end

  local axis
  if client.immobilized_horizontal and client.immobilized_vertical then
    axis = "none"
  elseif client.immobilized_horizontal then
    axis = "vertical"
  elseif client.immobilized_vertical then
    axis = "horizontal"
  end

  local coords = capi.mouse.coords()
  local corner = M.get_resize_corner(client, coords)

  amresize(client, "mouse.resize", {
    placement = aplacement.resize_to_mouse,
    corner = corner,
    include_sides = true,
    axis = axis,
  })
end

---@type table<client, screen>
local fullscreen_restore_screens = setmetatable({}, { __mode = "kv" })

---@param client client
---@param on_primary_screen? boolean
function M.fullscreen(client, on_primary_screen)
  local client_screen = client.screen
  if on_primary_screen then
    local primary_screen = capi.screen["primary"]
    if not client.fullscreen or client_screen ~= primary_screen then
      fullscreen_restore_screens[client] = client_screen
      client:move_to_screen(primary_screen)
      client.fullscreen = true
    else
      local restore_screen = fullscreen_restore_screens[client]
      if restore_screen and restore_screen ~= client_screen then
        client:move_to_screen(restore_screen)
        fullscreen_restore_screens[client] = nil
      end
      client.fullscreen = false
    end
  else
    if not client.fullscreen then
      fullscreen_restore_screens[client] = nil
      client.fullscreen = true
    else
      local restore_screen = fullscreen_restore_screens[client]
      if restore_screen and restore_screen ~= client_screen then
        client:move_to_screen(restore_screen)
        fullscreen_restore_screens[client] = nil
      end
      client.fullscreen = false
    end
  end
  client:raise()
end

return M
