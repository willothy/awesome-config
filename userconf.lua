------------------------
-- User Configuration --
------------------------
-- Main user configuration file. Here you may define your default
-- applications, UI scaling, and toggle features on/off.

-- Applications
---------------
-- Define your default applications, mainly used in 'config/keys.lua'
terminal     = "alacritty" or "xterm"
editor       = os.getenv("EDITOR")  or "nvim"
browser      = os.getenv("BROWSER") or "firefox"
top          = "htop"
files_cli    = "lf"
files_gui    = "thunar"
app_launcher = "rofi -show drun"

-- Options
----------
local user = {}

-- Settings
-----------
-- Mod4 is Super, Mod1 is Alt. 
user.modkey       = "Mod4"
-- Use the CapsLock key as an additional super key.
user.caps_super   = false
-- Should hovering a client with mouse focus it.
user.hover_focus  = false
-- Keyboard layouts to switch between using `mod + u`. Set both to your
-- main language to disable this behavior.
user.kb_layout1   = "us"
user.kb_layout2   = "latam"

-- Features
-----------
-- Enable/disable battery metrics and specify device to be used.
-- The device name is provided by the lgi Upower interface, I
-- believe it follows the `battery_XXXX` pattern where XXXX is
-- the `/sys/class/power_supply/` device name, e.g. BAT0/BAT1.
user.battery      = false
user.battery_name = "battery_BAT0"

-- Enable/disable brightness metrics and specify device to be used.
-- The device name is found in `/sys/class/backlight/`. Common examples
-- are "intel_backlight" and "amdgpu_bl0" for integrated graphics.
user.brightness      = false
user.brightness_name = "intel_backlight"

-- Enable/disable bluetooth metrics. No need to specify device name.
user.bluetooth    = false

-- UI
-----
-- The '*_size' variables are screen height percentages.
-- So, dash_size being 66 means it'll take 66% of my monitor height.

-- Resolution Scaling (vertical resolution of your monitor)
user.resolution   = 1080
-- Your monitor's aspect ratio, commonly 16:9 or 16:10.
user.aspect_ratio = 16/9
-- Your monitor's dpi. I'll be honest, don't touch this. I have literally
-- no idea how to deal with dpi scaling, and so changing it fucks stuff up.
-- Use it if you actually know what you're doing.
user.dpi          = 96

--- Bar Changes default state of the bar. Can still be brought up
-- by emitting the 'widget::bar' signal (mod + b) even if disabled.
user.bar_enabled  = true
user.bar_size     = 4.5
-- Can be 'top', 'bottom', 'right' or 'left'.
user.bar_pos      = "bottom"
-- Adds 'outer_gaps' to the bar.
user.bar_gap      = false

--- Titles
-- Toggles titlebars
user.title_enable = true
user.titles_size  = 3
-- Can be 'top', 'bottom', 'right' or 'left'.
user.titles_pos   = "left"

--- Dashboard
user.dash_size    = 66

--- Notifications
user.notif_size   = 9
-- Available positions:
-- Can be 'top_left', 'top_right', 'bottom_left' or 'bottom_right'.
user.notif_pos    = "top_right"

-- Gap configuration. 
--   Inner gaps are common gaps. 
--   Outer gaps are the gaps between the tag contents and the edge of the screen.
user.inner_gaps   = 0.4
user.outer_gaps   = user.inner_gaps * 3 -- Triple outer gap.

-- Borders (radius is relevant regardless of size)
user.border_size  = 0 --0.2 -- 2 pixel border on 1080p
user.border_rad   = 0.8

-- Theming
----------
-- Supported themes:
--  'catppuccin', 'tokyonight', 'everforest', 'everblush', 
--  'decay'
-- More themes can be added at 'themes/palettes'.
user.clr_palette  = "everblush"
-- GTK icon pack to use, 'default' (Papirus) or name.
user.icon_pack    = "default"

-- Fonts to be used. MUST leave a space at the end.
user.ui_font      = "Roboto "
user.ic_font      = "Material Icons "
user.mn_font      = "CaskaydiaCove Nerd Font "

-- Lua doesn't take '~' for home, use os.getenv('HOME').
-- Your *amazing* profile picture. Either 'default' or path.
user.avatar       = "default"
-- Your wallpaper path. Either 'default' (matches colorscheme) or path.
user.wall         = "default"
-- Music player fallback background. Either 'default' (matches colorscheme) or path.
user.player_bg    = "default"
-- AwesomeWM icon to be used, either 'default', 'nix' (both follow colorscheme) or path.
user.awm_icon     = "default"

-- Miscelaneous
---------------
-- Directory to save screenshots to (when prompted to do so).
user.scrnshot_dir = os.getenv("HOME") .. "/Pictures/"

-- Autostart
------------
-- Using `spawn.once` only spawns items at the beginning of the running session, and
-- not on reloads. `spawn` does actually run not running items on reload. 
local awful = require('awful')

awful.spawn.once("picom")

-- EOF
------
return user
