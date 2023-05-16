pcall(require, "luarocks.loader")

require("awful.autofocus")

require("awful").spawn.with_shell("~/.config/awesome/screens.sh")

require("signal.global")
require("user_likes")
require("autostart")
require("configuration")
require("ui")
