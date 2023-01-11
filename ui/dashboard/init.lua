--------------------------
-- unoriginal dashboard --
--------------------------

-- Imports
----------
local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears') 
local wibox     = require('wibox') 
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require('helpers')

dash_size         = scaling - bar_size - 3 * beautiful.useless_gap

local user_panel  = require('ui.dashboard.user_panel')
local qk_actions  = require('ui.dashboard.qk_actions')
local music       = require('ui.dashboard.music')
local sliders     = require('ui.dashboard.sliders')
local calendar    = require('ui.dashboard.calendar')

-- Dashboard
------------
-- The settings for the dashboard itself
local dashboardBox = wibox {
    ontop   = true,
    visible = false,
    width   = dpi(dash_size * 0.4),
    height  = dpi(dash_size),
    shape   = helpers.mkroundedrect(),
    bg      = beautiful.bg_normal
}

dashboardBox:setup {
    {
        {
            user_panel(),
            qk_actions(),
            music(),
            sliders(),
            calendar(),
            spacing = dpi(dash_size / 80),
            layout  = wibox.layout.fixed.vertical
        },
        margins = dpi(dash_size / 40),
        widget  = wibox.container.margin
    },
    bg     = beautiful.nbg,
    widget = wibox.container.background
}

-- Signal Connections
---------------------
awesome.connect_signal("widget::dashboard", function()
    dashboardBox.visible = not dashboardBox.visible
    if bar_pos == "left" then
        awful.placement.left(
            dashboardBox,
            {
                margins = {
                    left    = dpi(bar_size + beautiful.useless_gap * 2),
                },
                parent  = awful.screen.focused()
            }
        )
    elseif bar_pos == "right" then
        awful.placement.right(
            dashboardBox,
            {
                margins = {
                    right   = dpi(bar_size + beautiful.useless_gap * 2),
                },
                parent  = awful.screen.focused()
            }
        )
    elseif bar_pos == "top" then
        awful.placement.top_left(
            dashboardBox,
            {
                margins = {
                    top     = dpi(bar_size + beautiful.useless_gap * 2),
                    left    = dpi(beautiful.useless_gap)
                },
                parent  = awful.screen.focused()
            }
        )
    elseif bar_pos == "bottom" then
        awful.placement.bottom_left(
            dashboardBox,
            {
                margins = {
                    bottom  = dpi(bar_size + beautiful.useless_gap * 2),
                    left    = dpi(beautiful.useless_gap)
                },
                parent  = awful.screen.focused()
            }
        )
    end
end)
