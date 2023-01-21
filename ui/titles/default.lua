------------------------
-- Client Decorations --
------------------------

-- Imports
----------
local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require('helpers')

-- Buttons
----------
local mkbutton = function (width, color, onclick)
  return function(c)
    local button = wibox.widget {
      wibox.widget.textbox(),
      forced_width  = dpi(width),
      forced_height = dpi(titles_size * 2/3),
      bg            = color,
      shape         = helpers.mkroundedrect(beautiful.border_radius * 0.66),
      widget        = wibox.container.background
    }

    local color_transition = helpers.apply_transition {
      element   = button,
      prop      = 'bg',
      bg        = beautiful.titlebar_fg_focus,
      hbg       = beautiful.titlebar_fg_normal,
    }

    client.connect_signal("property::active", function ()
      if c.active then
        color_transition.off()
      else
        color_transition.on()
      end
    end)

    button:add_button(awful.button({}, 1, function ()
      if onclick then
        onclick(c)
      end
    end))

    return button
  end
end

local close = mkbutton(titles_size, beautiful.red, function(c)
    c:kill()
end)

local maximize = mkbutton(titles_size * 2/3, beautiful.ylw, function(c)
    c.maximized = not c.maximized
end)

local sticky = mkbutton(titles_size * 2/3, beautiful.grn, function(c)
    c.sticky = not c.sticky
end)

-- Titlebars
------------
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

    if c.requests_no_titlebar then
        return
    end
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    local n_titlebar = awful.titlebar(c, {
            size        = titles_size,
            position    = titles_pos,
        })
    n_titlebar.widget = {
        {
            { -- Left
                {
                  close(c),
                  direction = titles_type == "vertical" and "east" or "north",
                  widget    = wibox.container.rotate
                },
                {
                  maximize(c),
                  direction = titles_type == "vertical" and "east" or "north",
                  widget    = wibox.container.rotate
                },
                {
                  sticky(c),
                  direction = titles_type == "vertical" and "east" or "north",
                  widget    = wibox.container.rotate
                },
                spacing = dpi(titles_size / 6),
                layout  = titles_type == "horizontal"
                          and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
            },
            { -- Middle
                buttons = buttons,
                layout  = titles_type == "horizontal"
                          and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
            },
            { -- Right
                -- {
                --     titles_type == "horizontal" and awful.titlebar.widget.titlewidget(c),
                --     left   = titles_type == "horizontal" and dpi(titles_size / 2) or 0,
                --     top    = titles_type == "vertical" and dpi(titles_size / 2) or 0,
                --     widget = wibox.container.margin
                -- },
                buttons = buttons,
                layout  = titles_type == "horizontal"
                          and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
            },
            spacing = dpi(titles_size / 4),
            layout  = titles_type == "horizontal"
                      and wibox.layout.align.horizontal or wibox.layout.align.vertical
        },
        top     = titles_type == "horizontal" and dpi(titles_size / 5) or dpi(titles_size / 4),
        bottom  = titles_type == "horizontal" and dpi(titles_size / 5) or dpi(titles_size / 2),
        left    = titles_type == "horizontal" and dpi(titles_size / 4) or dpi(titles_size / 5),
        right   = titles_type == "horizontal" and dpi(titles_size / 2) or dpi(titles_size / 5),
        widget  = wibox.container.margin
    }
end)
