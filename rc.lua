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

require("signal.global")
require("autostart")
require("configuration")
require("ui")
