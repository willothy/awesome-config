---@diagnostic disable: lowercase-global
pcall(require, "luarocks.loader")

require("awful.autofocus")
local menubar = require("menubar")

terminal = "wezterm"
explorer = "nautilus"
browser = "brave"
launcher = "rofi -show drun"
editor = "nvim"
visual_editor = "nvim"
editor_cmd = "wezterm start nvim"
modkey = "Mod4" -- super, the windows key

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal

-- Register xproperty for WM_CLASS so it can be set with
-- client:set_xproperty("WM_CLASS", "class")
awesome.register_xproperty("WM_CLASS", "string")

require("signal.global")
require("autostart")
require("configuration")
require("ui")
