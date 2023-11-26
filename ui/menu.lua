---@diagnostic disable: undefined-global
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")

local menu = {}

menu.mainmenu = awful.menu({
	items = {
		{ "Terminal", terminal },
		{ "Explorer", explorer },
		{ "Browser", browser },
		{ "Restart", awesome.restart },
		{
			"Logout",
			function()
				awesome.quit()
			end,
		},
	},
})

return menu
