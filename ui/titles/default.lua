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
      forced_height = dpi(beautiful.titles_size),
      bg            = color,
      shape         = helpers.mkroundedrect(beautiful.border_radius * 0.5),
      widget        = wibox.container.background
    }

    local color_transition = helpers.apply_transition {
      element   = button,
      prop      = 'bg',
      bg        = color,
      hbg       = beautiful.blk,
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

local close = mkbutton(beautiful.titles_size * 4/3, beautiful.red, function(c)
    c:kill()
end)

local maximize = mkbutton(beautiful.titles_size * 3/4, beautiful.ylw, function(c)
    c.maximized = not c.maximized
end)

local sticky = mkbutton(beautiful.titles_size * 3/4, beautiful.grn, function(c)
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
            size        = beautiful.titles_size,
            position    = beautiful.titles_position,
        })
    n_titlebar.widget = {
        {
            { -- Left
                {
                  close(c),
                  direction = beautiful.titles_type == "vertical" and "east" or "north",
                  widget    = wibox.container.rotate
                },
                {
                  maximize(c),
                  direction = beautiful.titles_type == "vertical" and "east" or "north",
                  widget    = wibox.container.rotate
                },
                {
                  sticky(c),
                  direction = beautiful.titles_type == "vertical" and "east" or "north",
                  widget    = wibox.container.rotate
                },
                spacing = dpi(beautiful.titles_size / 4),
                layout  = beautiful.titles_type == "horizontal"
                          and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
            },
            { -- Middle
                buttons = buttons,
                layout  = beautiful.titles_type == "horizontal"
                          and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
            },
            { -- Right
                -- {
                --     beautiful.titles_type == "horizontal" and awful.titlebar.widget.titlewidget(c),
                --     left   = beautiful.titles_type == "horizontal" and dpi(beautiful.titles_size / 2) or 0,
                --     top    = beautiful.titles_type == "vertical" and dpi(beautiful.titles_size / 2) or 0,
                --     widget = wibox.container.margin
                -- },
                buttons = buttons,
                layout  = beautiful.titles_type == "horizontal"
                          and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
            },
            spacing = dpi(beautiful.titles_size / 4),
            layout  = beautiful.titles_type == "horizontal"
                      and wibox.layout.align.horizontal or wibox.layout.align.vertical
        },
        top     = beautiful.titles_type == "horizontal" and dpi(beautiful.titles_size / 3) or dpi(beautiful.titles_size / 3),
        bottom  = beautiful.titles_type == "horizontal" and dpi(beautiful.titles_size / 3) or dpi(beautiful.titles_size / 2),
        left    = beautiful.titles_type == "horizontal" and dpi(beautiful.titles_size / 3) or dpi(beautiful.titles_size / 3),
        right   = beautiful.titles_type == "horizontal" and dpi(beautiful.titles_size / 2) or dpi(beautiful.titles_size / 3),
        widget  = wibox.container.margin
    }
end)
