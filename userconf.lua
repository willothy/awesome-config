------------------------
-- User Configuration --
------------------------
-- Main user configuration file. Here you may define your default
-- applications, UI scaling, and toggle features on/off.

-- Imports
----------
local awful     = require('awful')
local dpi       = require('beautiful').xresources.apply_dpi

-- Global Variables
-------------------
-- 'config/actions/language' uses the 'caps:super' option, you
-- may wanna disable that if you don't use caps as super.
modkey       = "Mod4" -- 4 is super, 1 is alt.
-- Focus mouse hovered clients.
hover_focus  = false
-- Enables/disables battery metrics.
battery      = false
-- Enables/disables brightness metrics.
brightness   = false
-- Enables/disables bluetooth status.
bluetoothctl = false

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

-- Settings
-----------
local user = {}

-- UI
-----
-- The '*_size' variables are screen height percentages.
-- So, dash_size being 66 means it'll take 66% of my monitor height.

-- Resolution Scaling (vertical resolution of your monitor)
user.resolution   = 1080
-- Your monitor's aspect ratio, commonly 16:9 or 16:10.
user.aspect_ratio = 16/9
-- dpi
require('beautiful').xresources.set_dpi(96)

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
awful.spawn.once("picom")

return user
