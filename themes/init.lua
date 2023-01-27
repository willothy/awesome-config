----------------------
-- theming settings --
----------------------

-- Imports
----------
local awful     = require('awful')
local gears     = require('gears')
local beautiful = require('beautiful')
local wibox     = require('wibox')
local gc        = gears.color
local gfs       = gears.filesystem
local dpi       = beautiful.xresources.apply_dpi

local user      = require('userconf')

beautiful.xresources.set_dpi(user.dpi)

local clrs      = require('themes.palettes.' .. user.clr_palette)
local asst_dir  = gfs.get_configuration_dir() .. "themes/assets/"
local pltt_dir  = gfs.get_configuration_dir() .. "themes/palettes/" .. user.clr_palette .. "/"
local awes_dir  = gfs.get_themes_dir() .. "default/layouts/"

local theme     = {}

-- Colors
---------
theme.nbg   = clrs.nbg
theme.lbg   = clrs.lbg
theme.blk   = clrs.blk
theme.gry   = clrs.gry
theme.wht   = clrs.wht
theme.dfg   = clrs.dfg
theme.nfg   = clrs.nfg

theme.red   = clrs.red
theme.red_d = clrs.red_d
theme.grn   = clrs.grn
theme.grn_d = clrs.grn_d
theme.ylw   = clrs.ylw
theme.ylw_d = clrs.ylw_d
theme.blu   = clrs.blu
theme.blu_d = clrs.blu_d
theme.mag   = clrs.mag
theme.mag_d = clrs.mag_d
theme.cya   = clrs.cya
theme.cya_d = clrs.cya_d

-- General
theme.bg_normal = theme.nbg
theme.bg_focus  = theme.lbg
theme.bg_urgent = theme.blk
theme.fg_normal = theme.nfg
theme.fg_focus  = theme.nfg
theme.fg_urgent = theme.red

-- Settings
-----------
-- General
theme.modkey                  = user.modkey
theme.caps_super              = user.caps_super
theme.kb_layout1              = user.kb_layout1
theme.kb_layout2              = user.kb_layout2
if theme.caps_super then
    awful.spawn.once('setxkbmap '.. theme.kb_layout1 ..' -option caps:super')
end
theme.hover_focus             = user.hover_focus

-- features
theme.battery_enabled         = user.battery
theme.battery_name            = user.battery_name
theme.brightness_enabled      = user.brightness
theme.brightness_name         = user.brightness_name
theme.bluetooth_enabled       = user.bluetooth

-- user configuration variables
theme.resolution              = user.resolution / 100
theme.aspect_ratio            = user.aspect_ratio
theme.screenshot_dir          = user.scrnshot_dir
theme.border_radius           = user.border_rad * theme.resolution
theme.useless_gap             = dpi(user.inner_gaps * theme.resolution)
theme.outer_gaps              = user.outer_gaps * theme.resolution
theme.rounded_clients         = user.round_client

-- fonts
theme.ui_font                 = user.ui_font
theme.ic_font                 = user.ic_font
theme.mn_font                 = user.mn_font
-- default font
theme.font                    = theme.ui_font .. "Medium " .. theme.resolution * 0.92

-- theming
theme.wallpaper               = user.wall == "default" and pltt_dir .. "wall.png"
                                or user.wall
theme.user_avatar             = user.avatar == "default" and asst_dir .. "user.png"
                                or user.avatar
theme.player_bg               = user.player_bg == "default" and pltt_dir .. "player.png"
                                or user.player_bg
theme.icon_theme              = user.icon_pack == "default" and "Papirus" or user.icon_pack

-- bar
theme.bar_enabled             = user.bar_enabled
theme.bar_gap                 = user.bar_gap
theme.bar_size                = user.bar_size * theme.resolution
theme.bar_position            = user.bar_pos
theme.bar_type                = (theme.bar_position == "left" or theme.bar_position == "right") and "vertical" or "horizontal"
theme.wibar_bg                = theme.bg_normal
theme.wibar_fg                = theme.fg_normal

-- titles
theme.titles_enabled          = user.title_enable
theme.titles_size             = user.titles_size * theme.resolution
theme.titles_position         = user.titles_pos
theme.titles_type             = (theme.titles_position == "left" or theme.titles_position == "right") and "vertical" or "horizontal"
theme.titlebar_font           = theme.ui_font .. "Bold " .. theme.resolution
theme.titlebar_bg_focus       = theme.lbg
theme.titlebar_fg_focus       = theme.wht
theme.titlebar_bg_normal      = theme.lbg
theme.titlebar_fg_normal      = theme.lbg
theme.titlebar_bg_urgent      = theme.fg_urgent
theme.titlebar_fg_urgent      = theme.red_d

-- dashboard
theme.dashboard_size          = user.dash_size * theme.resolution

-- notifications
theme.notification_position   = user.notif_pos
theme.notif_size              = user.notif_size * theme.resolution
theme.notification_padding    = dpi(theme.useless_gap * 4)
theme.notification_spacing    = dpi(theme.notification_padding / 2)
theme.notification_accent     = theme.grn

-- Layouts
theme.gap_single_client       = true
theme.master_width_factor     = 0.56
theme.layout_tile             = gc.recolor_image(awes_dir .. "tilew.png",       theme.fg_normal)
theme.layout_tileleft         = gc.recolor_image(awes_dir .. "tileleftw.png",   theme.fg_normal)
theme.layout_tilebottom       = gc.recolor_image(awes_dir .. "tilebottomw.png", theme.fg_normal)
theme.layout_tiletop          = gc.recolor_image(awes_dir .. "tiletopw.png",    theme.fg_normal)
theme.layout_fairv            = gc.recolor_image(awes_dir .. "fairvw.png",      theme.fg_normal)
theme.layout_floating         = gc.recolor_image(awes_dir .. "floating.png",    theme.fg_normal)
-- theme.layout_fairh            = gc.recolor_image(awes_dir .. "fairhw.png",      theme.fg_normal)
-- theme.layout_cornernw         = gc.recolor_image(awes_dir .. "cornernww.png",   theme.fg_normal)
-- theme.layout_cornerne         = gc.recolor_image(awes_dir .. "cornernew.png",   theme.fg_normal)
-- theme.layout_cornersw         = gc.recolor_image(awes_dir .. "cornersww.png",   theme.fg_normal)
-- theme.layout_cornerse         = gc.recolor_image(awes_dir .. "cornersew.png",   theme.fg_normal)
theme.mstab_tabbar_style      = "modern"

-- border settings
theme.border_width            = dpi(user.border_size * theme.resolution)
theme.border_width_maximized  = dpi(theme.border_width)
theme.fullscreen_hide_border  = true
theme.border_color_active     = theme.titlebar_bg_focus
theme.border_color_normal     = theme.titlebar_bg_normal
theme.border_color_urgent     = theme.titlebar_bg_urgent

-- menu settings
theme.menu_font               = theme.ui_font .. "Bold " .. theme.resolution
theme.menu_height             = dpi(theme.resolution * 3.5)
theme.menu_width              = dpi(theme.menu_height * 5)
theme.menu_fg_focus           = theme.fg_focus
theme.menu_bg_focus           = theme.bg_focus
theme.menu_fg_normal          = theme.fg_normal
theme.menu_bg_normal          = theme.bg_normal
theme.menu_border_color       = theme.bg_focus
theme.menu_border_width       = theme.border_width
theme.menu_submenu_icon       = gc.recolor_image(asst_dir .. "menu_expand.svg", theme.fg_focus)

-- task/taglist settings
theme.tasklist_plain_task_name   = true
theme.tasklist_disable_icon      = false
theme.tasklist_disable_task_name = true
theme.tasklist_align             = "center"
theme.tasklist_bg_normal         = theme.bg_normal
theme.tasklist_bg_focus          = theme.blk
theme.tasklist_bg_urgent         = theme.fg_urgent
theme.taglist_bg_focus           = theme.ylw
theme.taglist_bg_occupied        = theme.ylw_d
theme.taglist_bg_empty           = theme.gry
theme.taglist_bg_urgent          = theme.fg_urgent

-- Awesome icon
if user.awm_icon == "default" then
    theme.awesome_icon = require('beautiful.theme_assets').awesome_icon(dpi(theme.resolution * 10), theme.fg_normal, theme.bg_normal)
elseif user.awm_icon == "arch" then
    theme.awesome_icon = gc.recolor_image(asst_dir .. "distro/arch.svg", theme.cya)
elseif user.awm_icon == "debian" then
    theme.awesome_icon = gc.recolor_image(asst_dir .. "distro/debian.svg", theme.red_d)
elseif user.awm_icon == "fedora" then
    theme.awesome_icon = gc.recolor_image(asst_dir .. "distro/fedora.svg", theme.blu)
elseif user.awm_icon == "nix" then
    theme.awesome_icon = gc.recolor_image(asst_dir .. "distro/nix.svg", theme.blu)
elseif user.awm_icon == "ubuntu" then
    theme.awesome_icon = gc.recolor_image(asst_dir .. "distro/ubuntu.svg", theme.red)
elseif user.awm_icon == "void" then
    theme.awesome_icon = gc.recolor_image(asst_dir .. "distro/void.svg", theme.grn)
else
    theme.awesome_icon = user.awm_icon
end

-- Tooltip
theme.tooltip_bg              = theme.bg_focus
theme.tooltip_fg              = theme.fg_normal
theme.tooltip_font            = theme.font
theme.tooltip_shape           = gears.shape.rounded_rect

-- Snap
theme.snap_bg                 = theme.taglist_bg_focus
theme.snap_border_width       = dpi(theme.titles_size / 2)
theme.snap_shape              = gears.shape.rectangle

-- Systray
theme.systray_max_rows        = 1
theme.systray_icon_spacing    = dpi(theme.useless_gap / 2)

-- Wallpaper setting
--[[ awful.spawn.once("feh --bg-fill --no-xinerama " .. theme.wallpaper) ]]
gears.wallpaper.maximized(theme.wallpaper)

return theme
