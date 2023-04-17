local xresources = require("beautiful.xresources")
local gears = require("gears")
local gfs = require("gears.filesystem")

local dpi = xresources.apply_dpi

local minimus = {
	turquoise = "#5de4c7",
	tiffany_blue = "#85e2da",
	pale_azure = "#89ddff",
	uranian_blue = "#add7ff",
	powder_blue = "#91b4d5",
	cadet_gray = "#8da3bf",
	cool_gray = "#7f92aa",
	raisin_black = "#1b1e28",
	colombia_blue = "#c5d2df",
	persian_red = "#be3937",
	lemon_chiffon = "#fffac2",
	tea_rose = "#e8b1b0",
	lavender_pink = "#fcc5e9",
	pale_purple = "#fee4fc",
	pale_turquoise = "#baf5e8", --"#d0e9f5",
	white = "#f1f1f1",
	black = "#1f1f1f",
	----------------------
	gunmetal = "#303340",
	dark_blue = "#26283f",
	----------------------
	rosewater = "#F5E0DC",
	flamingo = "#F2CDCD",
	pink = "#F5C2E7",
	mauve = "#CBA6F7",
	red = "#F38BA8",
	maroon = "#EBA0AC",
	peach = "#FAB387",
	yellow = "#F9E2AF",
	green = "#A6E3A1",
	teal = "#94E2D5",
	sky = "#89DCEB",
	sapphire = "#74C7EC",
	blue = "#89B4FA",
	lavender = "#B4BEFE",
	---------------------
	text = "#e4f0fb",
	none = "none",
}

-- paths
local themes_path = gfs.get_themes_dir()
local assets_path = gfs.get_configuration_dir() .. "assets/"

-- assets
local icons_path = assets_path .. "icons/"
local shapes_path = assets_path .. "shapes/"
local titlebar_assets_path = assets_path .. "titlebar/"

local theme = {}

local function clamp(component)
	return math.min(math.max(component, 0), 255)
end

local function brightness_mod(col, amt)
	local num = tonumber(col, 16)
	local r = math.floor(num / 0x10000) + amt
	local g = (math.floor(num / 0x100) % 0x100) + amt
	local b = (num % 0x100) + amt
	return string.format("%#x", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
end

-- fonts
theme.font_name = "Product Sans"
theme.nerd_font = "Iosevka NF"
theme.material_icons = "Material Icons"
theme.font_size = "10"
theme.font = theme.font_name .. " " .. theme.font_size

-- base colors
theme.black = "#151720"
theme.dimblack = "#1a1c25"
theme.light_black = "#262831"
theme.grey = "#666891"
theme.red = "#dd6777"
theme.red_dark = "#de495d"
theme.yellow = "#ecd3a0"
theme.yellow_dark = "#e3b964"
theme.magenta = "#c296eb"
theme.green = "#90ceaa"
theme.green_dark = "#66ad84"
theme.blue = "#86aaec"
theme.cyan = "#93cee9"
theme.aqua = "#7bd9e6"
theme.dark_blue = minimus.dark_blue

-- backgrounds
theme.bg_normal = "#0d0f18"
-- theme.bg_normal = minimus.dark_blue
theme.bg_contrast = "#0f111a"
-- theme.bg_contrast = minimus.dark_blue
theme.bg_lighter = "#11131c"

-- elements bg
theme.bg_focus = theme.bg_normal
theme.bg_urgent = theme.red
theme.bg_minimize = theme.bg_normal
theme.bg_systray = theme.bg_normal

-- foregrounds
theme.fg_normal = "#a5b6cf"
theme.fg_focus = theme.fg_normal
theme.fg_urgent = theme.fg_normal
theme.fg_minimize = theme.fg_normal

-- some actions bg colors
theme.actions = {
	bg = theme.bg_normal,
	contrast = theme.bg_contrast,
	lighter = theme.bg_lighter,
	fg = theme.fg_normal,
}

-- bar
theme.bar_height = 40

-- gaps and borders
theme.useless_gap = dpi(4)
theme.border_width = dpi(0)
theme.border_color_normal = theme.bg_normal
theme.border_color_active = theme.bg_normal
theme.border_color_marked = theme.bg_normal
theme.border_radius = dpi(10)

-- tasklist
theme.tasklist_plain_task_name = true
theme.tasklist_bg = theme.bg_normal
theme.tasklist_bg_focus = theme.dimblack
theme.tasklist_bg_urgent = theme.red .. "4D" -- 30% of transparency

-- taglist
theme.taglist_bg = theme.bg_normal
theme.taglist_bg_urgent = theme.taglist_bg
theme.normal_tag_format = assets_path .. "taglist/screen-full-svgrepo-com.svg"
theme.occupied_tag_format = theme.normal_tag_format
theme.selected_tag_format = assets_path .. "taglist/screen-normal-svgrepo-com.svg"
theme.taglist_fg_focus = theme.yellow
theme.taglist_fg = theme.dimblack
theme.taglist_fg_occupied = theme.blue

-- systray
theme.systray_icon_spacing = dpi(12)
theme.systray_max_rows = 7
theme.tray_chevron_up = gears.color.recolor_image(assets_path .. "tray/up.svg", theme.fg_normal)
theme.tray_chevron_down = gears.color.recolor_image(assets_path .. "tray/down.svg", theme.fg_normal)

-- menu
theme.menu_font = theme.font
theme.menu_submenu_icon = gears.color.recolor_image(shapes_path .. "triangle.png", theme.fg_normal)
theme.menu_height = dpi(40)
theme.menu_width = dpi(180)
theme.menu_bg_focus = theme.bg_lighter

-- titlebar
-- theme.titlebar_bg = theme.dark_blue
theme.titlebar_bg_normal = theme.dark_blue
theme.titlebar_bg_focus = theme.dark_blue
-- theme.titlebar_bg = theme.bg_contrast
-- theme.titlebar_bg_focus = theme.bg_normal
-- theme.titlebar_fg = theme.fg_normal

-- close
theme.titlebar_close_button_normal = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.red)
theme.titlebar_close_button_normal_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.red_dark)
theme.titlebar_close_button_focus = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.red)
theme.titlebar_close_button_focus_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.red_dark)

-- maximized
theme.titlebar_maximized_button_normal_active =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green)
theme.titlebar_maximized_button_normal_inactive =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green)
theme.titlebar_maximized_button_focus_active =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green)
theme.titlebar_maximized_button_focus_inactive =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green)
theme.titlebar_maximized_button_normal_active_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green_dark)
theme.titlebar_maximized_button_normal_inactive_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green_dark)
theme.titlebar_maximized_button_focus_active_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green_dark)
theme.titlebar_maximized_button_focus_inactive_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green_dark)

-- minimize
theme.titlebar_minimize_button_normal = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)
theme.titlebar_minimize_button_normal_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow_dark)
theme.titlebar_minimize_button_focus_hover =
	gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow_dark)

-- wallpaper
theme.wallpaper = assets_path .. "wallpaper.jpg"

-- layouts
theme.layout_fairh = gears.color.recolor_image(themes_path .. "default/layouts/fairhw.png", theme.fg_normal)
theme.layout_fairv = gears.color.recolor_image(themes_path .. "default/layouts/fairvw.png", theme.fg_normal)
theme.layout_floating = gears.color.recolor_image(themes_path .. "default/layouts/floatingw.png", theme.fg_normal)
theme.layout_magnifier = gears.color.recolor_image(themes_path .. "default/layouts/magnifierw.png", theme.fg_normal)
theme.layout_max = gears.color.recolor_image(themes_path .. "default/layouts/maxw.png", theme.fg_normal)
theme.layout_fullscreen = gears.color.recolor_image(themes_path .. "default/layouts/fullscreenw.png", theme.fg_normal)
theme.layout_tilebottom = gears.color.recolor_image(themes_path .. "default/layouts/tilebottomw.png", theme.fg_normal)
theme.layout_tileleft = gears.color.recolor_image(themes_path .. "default/layouts/tileleftw.png", theme.fg_normal)
theme.layout_tile = gears.color.recolor_image(themes_path .. "default/layouts/tilew.png", theme.fg_normal)
theme.layout_tiletop = gears.color.recolor_image(themes_path .. "default/layouts/tiletopw.png", theme.fg_normal)
theme.layout_spiral = gears.color.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.fg_normal)
theme.layout_dwindle = gears.color.recolor_image(themes_path .. "default/layouts/dwindlew.png", theme.fg_normal)
theme.layout_cornernw = gears.color.recolor_image(themes_path .. "default/layouts/cornernww.png", theme.fg_normal)
theme.layout_cornerne = gears.color.recolor_image(themes_path .. "default/layouts/cornernew.png", theme.fg_normal)
theme.layout_cornersw = gears.color.recolor_image(themes_path .. "default/layouts/cornersww.png", theme.fg_normal)
theme.layout_cornerse = gears.color.recolor_image(themes_path .. "default/layouts/cornersew.png", theme.fg_normal)

-- icons
theme.launcher_icon = gears.color.recolor_image(icons_path .. "launcher.svg", theme.blue)
theme.menu_icon = gears.color.recolor_image(icons_path .. "menu.svg", theme.fg_normal)
theme.hints_icon = gears.color.recolor_image(icons_path .. "hints.svg", theme.blue)
theme.powerbutton_icon = gears.color.recolor_image(icons_path .. "poweroff.svg", theme.red)
theme.poweroff_icon = icons_path .. "poweroff.svg"

theme.volume_on = gears.color.recolor_image(icons_path .. "volume-on.svg", theme.fg_normal)
theme.volume_muted = gears.color.recolor_image(icons_path .. "volume-muted.svg", theme.fg_normal)

theme.network_connected = "  "
theme.network_disconnected = "睊 "

-- pfp
theme.pfp = assets_path .. "pfp.png"

-- fallback music
theme.fallback_music = assets_path .. "fallback-music.png"

-- fallback notification icon
theme.fallback_notif_icon = gears.color.recolor_image(icons_path .. "hints.svg", theme.blue)

-- disable icon theme
theme.icon_theme = nil

-- task preview
theme.task_preview_widget_border_radius = dpi(7)
theme.task_preview_widget_bg = theme.bg_normal
theme.task_preview_widget_border_color = theme.bg_normal
theme.task_preview_widget_border_width = 0
theme.task_preview_widget_margin = dpi(10)

-- tag preview
theme.tag_preview_widget_border_radius = dpi(1)
theme.tag_preview_client_border_radius = dpi(1)
theme.tag_preview_client_opacity = 0.5
theme.tag_preview_client_bg = theme.bg_lighter
theme.tag_preview_client_border_color = theme.blue
theme.tag_preview_client_border_width = 1
theme.tag_preview_widget_bg = theme.bg_normal
theme.tag_preview_widget_border_color = theme.bg_normal
theme.tag_preview_widget_border_width = 0
theme.tag_preview_widget_margin = dpi(7)

-- tooltip
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal

return theme
