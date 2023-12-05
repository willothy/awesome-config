local M = {}

local awful = Capi.awful
local beautiful = Capi.beautiful
local wibox = Capi.wibox

client.connect_signal("request::titlebars", function(c)
  if c.instance == "spad" then
    return
  end

  local titlebar = awful.titlebar(c, {
    position = "top",
    size = 30,
    -- TODO: match color to top of window
    bg_focus = beautiful.dark_blue,
    bg_normal = beautiful.dark_blue,
  })

  local title_actions = {
    awful.button({}, 1, function()
      c:activate({
        context = "titlebar",
        action = "mouse_move",
      })
    end),
    awful.button({}, 3, function()
      c:activate({
        context = "titlebar",
        action = "mouse_resize",
      })
    end),
  }

  local buttons_loader = {
    layout = wibox.layout.fixed.horizontal,
    buttons = title_actions,
  }

  local function padded_button(button, margins)
    margins = margins or {
      left = 4,
      right = 4,
    }
    margins.top = 6
    margins.bottom = 6

    return wibox.widget({
      button,
      top = margins.top,
      bottom = margins.bottom,
      left = margins.left,
      right = margins.right,
      widget = wibox.container.margin,
    })
  end

  titlebar:setup({
    {
      {
        padded_button(awful.titlebar.widget.closebutton(c), {
          right = 4,
          left = 12,
        }),
        padded_button(awful.titlebar.widget.minimizebutton(c)),
        padded_button(awful.titlebar.widget.maximizedbutton(c)),
        layout = wibox.layout.fixed.horizontal,
      },
      widget = wibox.container.margin,
      margins = {
        top = 4,
      },
    },
    buttons_loader,
    buttons_loader,
    layout = wibox.layout.align.horizontal,
  })
end)

return M
