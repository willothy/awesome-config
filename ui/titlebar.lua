---@diagnostic disable: undefined-global

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

client.connect_signal("request::titlebars", function(c)
	local titlebar = awful.titlebar(c, {
		position = "top",
		size = dpi(28),
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
		margins.top = 8
		margins.bottom = 8

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
			padded_button(awful.titlebar.widget.closebutton(c), {
				right = 4,
				left = 12,
			}),
			padded_button(awful.titlebar.widget.minimizebutton(c)),
			padded_button(awful.titlebar.widget.maximizedbutton(c)),
			layout = wibox.layout.fixed.horizontal,
		},
		buttons_loader,
		buttons_loader,
		layout = wibox.layout.align.horizontal,
	})
end)
