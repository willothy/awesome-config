------------------------
-- User Configuration --
------------------------
-- Main user configuration file. Here you may define your default
-- applications, UI scaling, and toggle features on/off.

-- Applications
---------------
-- These are mandatory, and therefore cannot be commented or deleted.
-- Define your default applications, mainly used in 'config/keys.lua'
terminal = "wezterm"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor
browser = os.getenv("BROWSER") or "chromium"
top = "htop"
files_cli = "fzf"
files_gui = "nautilus"

-- Options
----------
local user = {}

-- Settings
-----------
--- Mod4 is Super, Mod1 is Alt. Defaults to "Mod4".
user.modkey = "Mod4"
-- user.kb_layout1   = "us"
-- user.kb_layout2   = "latam"

--- Enable/disable bluetooth metrics. No need to specify device name.
--- Defaults to false.
user.bluetooth = true

-- UI
-----
--- The '*_size' variables are screen height percentages.
--- So, dash_size being 66 means it'll take 66% of my monitor height.

--- Vertical Resolution of your monitor. Defaults to 1080.
-- user.resolution = 1080
--- Your monitor's aspect ratio, commonly 16:9 or 16:10. Defaults to 16/9.
-- user.aspect_ratio = 21 / 9
--- Your monitor's dpi. May or may not be extremely breaking to the UI.
--- Use it if you actually know what you're doing. Comment to use your
--- monitor's default (recommended). These dots where built on dpi 96.
-- user.dpi          = 96

--- Bar
user.bar_enabled = true
user.bar_size = 3.5
user.bar_pos = "top"
user.bar_gap = false

--- Titles
--- Toggles titlebars. Defaults to true.
user.title_enable = true
--- Toggles inverted titlebar layout. Defaults to false.
-- user.title_invert = true
--- Titlebars size (screen %). Defaults to 3.
-- user.titles_size = 3
--- Can be 'top', 'bottom', 'right' or 'left'. Defaults to 'top'.
-- user.titles_pos = "right"

--- Dashboard
--- Dashboard size (screen %). Defaults to 75.
-- user.dash_size    = 75

--- Notifications
--- Notification size (screen %). Defaults to 9.
-- user.notif_size   = 9
--- Can be 'top_left', 'top_right', 'bottom_left' or 'bottom_right'.
--- Avoids bar by default.
-- user.notif_pos    = "top_left"

--- Gaps.
---   Inner gaps are common gaps. Default to 0.4.
---   Outer gaps are the gaps between the tag contents and the edge of the
---   screen. Default to 3 times `inner_gaps`.
user.inner_gaps = 0.2 --0.4
user.outer_gaps = 0 --user.inner_gaps * 3 -- Triple outer gap.

--- Borders
--- Size of borders used on windows and some widgets (screen %). Defaults to 0.
-- user.border_size = 0.2 -- 2 pixel border on 1080p
--- Radius of borders used on windows and some widgets. Defaults to 0.8.
user.border_rad = 0.5
--- Should clients/windows be rounded using `border_rad`. Defaults to false.
-- user.round_client = true

-- Theming
----------
--- Supported themes:
---  dark:
---    'everblush', 'everforest', 'tokyonight', 'mar'
---  light:
---    'gruvbox', 'solarized', 'plata'
--- More themes can be added at `themes/palettes`. DOES NOT have a default.
user.clr_palette = "tokyonight"

--- Default to 'IBM Plex Sans', 'Material Icons' and 'IBM Plex Mono' respectively.
user.ui_font = "FiraCode Nerd Font"
-- user.ic_font      = "Material Icons"
-- user.mn_font      = "IBM Plex Mono"

user.avatar = os.getenv("HOME") .. "/Pictures/av.png"
-- user.wall         = os.getenv("HOME") .. "/Pictures/walls/everblush/Smily.jpg"
user.player_bg = "/usr/share/backgrounds/forest.jpg"
--- AwesomeWM icon to be used (comment for default awesome icon):
---   'arch', 'debian', 'fedora', 'nix', 'ubuntu' or 'void'.
user.awm_icon = "arch"

--- Terminal scratchpad. Brought up with `mod + Ctrl + Return`.
--- Horizontal screen percentage used as width. Defaults to 40.
-- user.scratch_wide = 40
--- Vertical screen percentage used as height. Defaults to 66.
-- user.scratch_high = 66

-- Autostart
------------
-- Using `spawn.once` only spawns items at the beginning of the running session, and
-- not on reloads. `spawn` does actually run not running items on reload.
local awful = require("awful")

-- EOF
------
return user
