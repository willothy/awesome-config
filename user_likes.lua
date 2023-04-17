local menubar = require("menubar")

terminal = "wezterm"
explorer = "nautilus"
browser = "chromium"
launcher = "rofi -show drun"
editor = os.getenv("EDITOR") or "vim"
visual_editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4" -- super, the windows key

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
