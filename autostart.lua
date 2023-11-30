-- autostart, just runs `autostart.sh`

local awful = require("awful")
local gfs = require("gears.filesystem")

local conf = gfs.get_configuration_dir()

local screens = conf .. "screens.sh"
awful.spawn.with_shell(screens)

-- awful.spawn("picom")
awful.spawn("compfy")

awful.spawn("nm-applet")
awful.spawn.with_shell(
  "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
)
