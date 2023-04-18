local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local wh_power_menu = {
	{
		name = "Logout",
		icon = beautiful.logout_icon,
		command = "awesome-client 'awesome.emit_signal(\"exit_screen::show\")'",
	},
	{ name = "Reboot", icon = beautiful.reboot_icon, command = "reboot" },
	{ name = "Shutdown", icon = beautiful.poweroff_icon, command = "shutdown now" },
}

local popup = awful.popup({
	ontop = true,
	visible = false,
	shape = helpers.mkroundedrect(),
	-- maximum_width = 300,
	offset = { y = 5 },
	widget = {},
})
local rows = { layout = wibox.layout.fixed.vertical }
for _, item in ipairs(wh_power_menu) do
	local row = wibox.widget({
		{
			{
				{
					{
						image = item.icon,
						markup = "<b>" .. item.name .. "</b>",
						forced_width = 16,
						forced_height = 16,
						widget = wibox.widget.imagebox,
					},
					{
						text = item.name,
						markup = "<b>" .. item.name .. "</b>",
						widget = wibox.widget.textbox,
					},
					spacing = 12,
					layout = wibox.layout.fixed.horizontal,
				},
				left = 16,
				right = 16,
				top = 8,
				bottom = 8,
				widget = wibox.container.margin,
			},
			bg = beautiful.bg_normal,
			shape = helpers.mkroundedrect(),
			widget = wibox.container.background,
		},
		top = 6,
		bottom = 6,
		left = 6,
		right = 6,
		widget = wibox.container.margin,
	})
	row:connect_signal("mouse::enter", function(c)
		c.widget:set_bg(beautiful.bg_focus)
		-- c.bg = beautiful.bg_focus
	end)
	row:connect_signal("mouse::leave", function(c)
		c.widget:set_bg(beautiful.bg_normal)
		-- c.bg = beautiful.bg_normal
	end)
	table.insert(rows, row)
end
popup:connect_signal("mouse::leave", function()
	popup.visible = false
end)
popup:setup(rows)
return popup
