---------------------------
-- dashboard: user panel --
---------------------------

-- Imports
----------
local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears') 
local wibox     = require('wibox') 
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require('helpers')

-- User profile
---------------
local avatar  = wibox.widget {
    widget        = wibox.widget.imagebox,
    image         = beautiful.user_avatar,
    clip_shape    = gears.shape.circle,
    resize        = true,
    forced_height = dpi(dash_size / 12),
}

local greeter = wibox.widget {
    markup = "Welcome, <b>user!</b>",
    font   = ui_font .. dash_size / 48,
    widget = wibox.widget.textbox
}
awful.spawn.easy_async_with_shell(
    "whoami", function(stdout)
        name           = stdout:match('(%w+)')
        greeter.markup = "<b>Hi,</b> " .. name
    end
)

local uptime = wibox.widget {
    text   = "Uptime unknown...",
    font   = ui_font .. dash_size / 96,
    widget = wibox.widget.textbox
}
local function get_uptime()
    awful.spawn.easy_async_with_shell(
        "uptime -p", function(stdout)
            uptime.text = stdout
        end)
end
gears.timer {
    timeout   = 60,
    call_now  = true,
    autostart = true,
    callback  = get_uptime
}

-- Battery
----------
local bat_bar = wibox.widget {
    {
        {
            id          = 'progressbar_role',
            color       = beautiful.grn,
            background_color = beautiful.nbg,
            max_value   = 100,
            clip        = true,
            bar_shape   = helpers.mkroundedrect(),
            shape       = helpers.mkroundedrect(),
            forced_height = dpi(dash_size / 32),
            forced_width  = dpi(dash_size / 12),
            widget      = wibox.widget.progressbar
        },
        {
            {
                {
                    id      = 'icon_role',
                    font    = ic_font .. dash_size / 72,
                    halign  = "left",
                    valign  = "center",
                    widget  = wibox.widget.textbox
                },
                fg      = beautiful.nbg,
                widget  = wibox.container.background
            },
            left   = dpi(dash_size / 128),
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack,
    },
    {
        {
            id      = 'text_role',
            font    = ui_font .. dash_size / 96, 
            widget  = wibox.widget.textbox
        },
        fg     = beautiful.wht,
        widget = wibox.container.background
    },
    spacing = dpi(dash_size / 128),
    layout  = wibox.layout.fixed.horizontal,
    set_value  = function(self, val)
        self:get_children_by_id('progressbar_role')[1].value = val
    end,
    set_icon   = function(self, new_icon)
        self:get_children_by_id('icon_role')[1].text = new_icon
    end,
    set_text   = function(self, new_text)
        self:get_children_by_id('text_role')[1].text = new_text
    end
}
if battery then
    awesome.connect_signal("signal::battery", function(level, state, discharge_t, charge_t, type)
        bat_bar.value  = level
        if state ~= 2 then
            bat_bar.icon = ""
            if state ~= 1 then
                bat_bar.text = "Fully Charged"
            else
                bat_bar.text = charge_t .. " mins"
            end
        else
            bat_bar.icon = ""
            bat_bar.text = discharge_t .. " mins"
        end
    end)
end

-- Power Buttons
----------------
local function txtbtn(icon, action)
    return wibox.widget {
        {
            text   = icon,
            font   = ic_font .. dash_size / 48,
            align  = "center",
            widget = wibox.widget.textbox,
            buttons = {
                awful.button({}, 1, 
                    function() awful.spawn(action) end)
            }
        },
        fg     = beautiful.red,
        widget = wibox.container.background
    } 
end
local shutdown = txtbtn("", "systemctl poweroff");
local reboot   = txtbtn("", "systemctl reboot");

local function user_profile()
    return wibox.widget {
    {
        {
            {
                {
                    avatar,
                    valign = "center",
                    layout = wibox.container.place
                },
                {
                    {
                        {
                            greeter, 
                            {
                                uptime,
                                fg     = beautiful.wht,
                                widget = wibox.container.background
                            },
                            spacing = dpi(-dash_size / 128),
                            layout  = wibox.layout.flex.vertical
                        },
                        valign = "center",
                        widget = wibox.container.place
                    },
                    left   = dpi(dash_size / 48),
                    right  = dpi(dash_size / 64),
                    widget = wibox.container.margin
                },
                layout  = wibox.layout.fixed.horizontal
            },
            left   = dpi(dash_size / 56),
            bottom = dpi(dash_size / 72),
            top    = dpi(dash_size / 72),
            right  = dpi(dash_size / 64),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        bat_bar,
                        margins = dpi(dash_size / 400),
                        visible = battery,
                        widget  = wibox.container.margin
                    },
                    nil,
                    {
                        helpers.mkbtn(reboot,   beautiful.lbg, beautiful.gry),
                        helpers.mkbtn(shutdown, beautiful.lbg, beautiful.gry),
                        spacing = dpi(dash_size / 220),
                        layout  = wibox.layout.fixed.horizontal
                    },
                    layout = wibox.layout.align.horizontal
                },
                margins = dpi(dash_size / 192),
                widget  = wibox.container.margin
            },
            bg     = beautiful.blk,
            widget = wibox.container.background
        },
        layout = wibox.layout.align.vertical
    },
    shape  = helpers.mkroundedrect(),
    bg     = beautiful.lbg,
    forced_height = dpi(dash_size / 6.4),
    widget = wibox.container.background
}
end

return user_profile
