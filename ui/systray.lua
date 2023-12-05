local M = {}

local wibox = Capi.wibox
local awful = Capi.awful
local beautiful = Capi.beautiful

function M.new(s)
  local systray = wibox.widget.systray({
    screen = s,
  })

  -- for some reason horizontal means
  -- vertical and vice versa
  ---@diagnostic disable-next-line: inject-field
  systray.horizontal = false

  local widget = wibox.widget({
    {
      systray,
      margins = {
        top = 2,
        bottom = 0,
        left = 0,
        right = 0,
      },
      widget = wibox.container.margin,
    },
    layout = wibox.layout.flex.vertical,
    valign = "center",
  })

  return widget
end

return M
