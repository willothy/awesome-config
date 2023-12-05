local M = {}

local awful = Capi.awful
local gears = Capi.gears
local wibox = Capi.wibox
local beautiful = Capi.beautiful

require("vendor.bling").widget.task_preview.enable({
  placement_fn = function(c)
    awful.placement.top(c, {
      margins = {
        top = beautiful.bar_height + beautiful.useless_gap * 2,
      },
    })
  end,
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
        margins = {
          left = 2,
          right = 2,
          top = 1,
          bottom = 1,
        },
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
      create_callback = function(self, c, _idx, _clients)
        local timed = require("vendor.rubato").timed({
          duration = 0.3,
          intro = 0.0,
          easing = require("vendor.rubato").easing.linear,
          subscribed = function(pos)
            if c == client.focus then
              return
            end
            self.bg = require("lib.color").interpolate(
              beautiful.bg_normal,
              beautiful.bg_focus,
              pos
            )
          end,
          clamp_position = true,
        })
        self:connect_signal("mouse::enter", function()
          timed.target = 1
          awesome.emit_signal("bling::task_preview::visibility", s, true, c)
        end)
        self:connect_signal("mouse::leave", function()
          timed.target = 0
          awesome.emit_signal("bling::task_preview::visibility", s, false, c)
        end)
      end,
    },
  })
end

return M
