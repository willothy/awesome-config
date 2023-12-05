local M = {}

local awful = Capi.awful
local beautiful = Capi.beautiful
local wibox = Capi.wibox
local gears = Capi.gears

function M.setup()
  screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag(
      { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
      s,
      awful.layout.layouts[1]
    )

    local taglist = require("ui.topbar.taglist").new(s)
    local tasklist = require("ui.topbar.tasklist").new(s)

    local layout_indicator = wibox.widget({
      awful.widget.layoutbox({
        screen = s,
        buttons = {
          awful.button({}, 1, function()
            awful.layout.inc(1)
          end),
          awful.button({}, 3, function()
            awful.layout.inc(-1)
          end),
          awful.button({}, 4, function()
            awful.layout.inc(-1)
          end),
          awful.button({}, 5, function()
            awful.layout.inc(1)
          end),
        },
        valign = "center",
        halign = "center",
      }),
      widget = wibox.container.margin,
      valign = "center",
      halign = "center",
      margins = {
        top = 2,
        bottom = 2,
      },
    })

    local topbar = awful.wibar({
      position = "top",
      screen = s,
      width = s.geometry.width,
      height = beautiful.bar_height,
      shape = gears.shape.rectangle,
    })

    local function mkcontainer(template)
      return wibox.widget({
        template,
        left = 8,
        right = 8,
        top = 6,
        bottom = 6,
        widget = wibox.container.margin,
      })
    end

    topbar:setup({
      {
        layout = wibox.layout.align.horizontal,
        {
          {
            taglist,
            margins = {
              left = beautiful.useless_gap * 2,
            },
            widget = wibox.container.margin,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        nil,
        {
          mkcontainer({
            s.index == screen.primary.index and awful.widget.textclock(
              "%H:%M"
            ) or nil,
            layout_indicator,
            -- s.index == screen.primary.index and volumebutton or nil,
            -- s.index == screen.primary.index and powerbutton or nil,

            spacing = 8,
            layout = wibox.layout.fixed.horizontal,
          }),
          layout = wibox.layout.fixed.horizontal,
        },
      },
      {
        mkcontainer({
          tasklist,
          layout = wibox.layout.fixed.horizontal,
        }),
        halign = "center",
        widget = wibox.container.margin,
        layout = wibox.container.place,
        margins = {
          right = beautiful.useless_gap * 2,
        },
      },
      layout = wibox.layout.stack,
    })
  end)
end

return M
