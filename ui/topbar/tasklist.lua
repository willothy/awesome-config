local M = {}

local awful = Capi.awful
local gears = Capi.gears
local wibox = Capi.wibox
local beautiful = Capi.beautiful

local dpi = beautiful.xresources.apply_dpi

require("vendor.bling").widget.task_preview.enable({
  -- height = dpi(300),
  -- width = dpi(300),
  -- y = beautiful.bar_height + (beautiful.useless_gap * 2),
  x = beautiful.useless_gap * 2,
  -- honor_workarea = true,
  -- honor_padding = true,
  placement_fn = function(c)
    -- c.screen = awful.screen.focused()
    awful.placement.center_horizontal(c)
    awful.placement.top(c, {
      margins = {
        top = beautiful.bar_height + beautiful.useless_gap * 2,
        right = 0,
        -- left = c.screen:get_bounding_geometry().width,
        -- left = c.screen:get_bounding_geometry({
        --   honor_workarea = true,
        -- }).x,
        -- left = 0,
        -- left = (c.screen.geometry.width / 2) + (beautiful.useless_gap * 2),
      },
    })
    -- c:set_xproperty("WM_CLASS", "task-preview")
  end,
  widget_structure = {
    {
      {
        {
          id = "icon_role",
          widget = awful.widget.clienticon, -- The client icon
        },
        {
          id = "name_role", -- The client name / title
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.flex.horizontal,
      },
      widget = wibox.container.margin,
      margins = 5,
    },
    {
      id = "image_role", -- The client preview
      resize = true,
      valign = "center",
      halign = "center",
      widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.vertical,
  },
})

function M.new(s)
  return awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    source = function()
      local ret = {}

      local found = {}

      for _, t in ipairs(s.tags) do
        for _, c in ipairs(t:clients()) do
          if not found[c] then
            table.insert(ret, c)
          end
          found[c] = true
        end
      end

      return ret
    end,
    buttons = {
      awful.button({}, 1, function(c)
        if not c.active then
          c:activate({
            context = "through_dock",
            switch_to_tag = true,
          })
        else
          c.minimized = true
        end
      end),
      awful.button({}, 4, function()
        awful.client.focus.byidx(-1)
      end),
      awful.button({}, 5, function()
        awful.client.focus.byidx(1)
      end),
    },
    style = {
      shape = function(cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, 5)
      end,
    },
    layout = {
      spacing = 5,
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          id = "icon_role",
          widget = wibox.widget.imagebox,
        },
        margins = 4,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
      create_callback = function(self, c, _idx, _clients)
        self:connect_signal("mouse::enter", function()
          awesome.emit_signal("bling::task_preview::visibility", s, true, c)
        end)
        self:connect_signal("mouse::leave", function()
          awesome.emit_signal("bling::task_preview::visibility", s, false, c)
        end)
      end,
    },
  })
end

return M
