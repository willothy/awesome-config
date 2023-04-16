local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

return function(c)
	local topbar = awful.titlebar(c, {
		height = 30,
		bg_normal = "#000000",
	})

	local buttons = gears.table.join(
		awful.button({}, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)

	topbar:setup({
		--left
		{
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		--center
		{
			{
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		--right
		{
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.align.horizontal,
	})
end
