local bling = require("bling")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

bling.widget.tag_preview.enable({
	show_client_content = false,
	scale = 0.20,
	honor_padding = false,
	honor_workarea = true,
	placement_fn = function(c)
		awful.placement.top_left(c, {
			margins = {
				top = beautiful.bar_height + beautiful.useless_gap * 2,
				left = beautiful.useless_gap * 2,
			},
		})
		c:set_xproperty("WM_CLASS", "tag-preview")
	end,
	background_widget = wibox.widget({
		image = beautiful.wallpaper,
		horizontal_fit_policy = "fit",
		vertical_fit_policy = "fit",
		widget = wibox.widget.imagebox,
	}),
})
