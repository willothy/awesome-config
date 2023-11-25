---@diagnostic disable: undefined-global, missing-parameter, param-type-mismatch
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

require("ui.powermenu")

local power_popup = require("ui.bar.power_menu")
local volume_popup = require("ui.bar.volume")

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

	local get_tags = require("ui.bar.tags")
	local taglist = get_tags(s)

	local tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		-- sort clients by tags
		source = function()
			local ret = {}

			for _, t in ipairs(s.tags) do
				gears.table.merge(ret, t:clients())
			end

			return ret
		end,
		buttons = {
			awful.button({}, 1, function(c)
				if not c.active then
					c:activate({
						context = "through_dock",
						switch_to_tag = true,
					})
				else
					c.minimized = true
				end
			end),
			awful.button({}, 4, function()
				awful.client.focus.byidx(-1)
			end),
			awful.button({}, 5, function()
				awful.client.focus.byidx(1)
			end),
		},
		style = {
			shape = helpers.mkroundedrect(),
		},
		layout = {
			spacing = dpi(5),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				margins = dpi(4),
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			create_callback = function(self, c, idx, clients)
				self:connect_signal("mouse::enter", function()
					awesome.emit_signal("bling::task_preview::visibility", s, true, c)
				end)
				self:connect_signal("mouse::leave", function()
					awesome.emit_signal("bling::task_preview::visibility", s, false, c)
				end)
			end,
		},
	})

	local clock_formats = {
		hour = "%I:%M %p",
		day = "%d/%m/%Y",
	}

	local clock = wibox.widget({
		format = clock_formats.hour,
		widget = wibox.widget.textclock,
	})

	local date = wibox.widget({
		{
			clock,
			fg = beautiful.blue,
			widget = wibox.container.background,
		},
		margins = dpi(7),
		widget = wibox.container.margin,
	})

	date:add_button(awful.button({}, 1, function()
		clock.format = clock.format == clock_formats.hour and clock_formats.day or clock_formats.hour
	end))

	local base_layoutbox = awful.widget.layoutbox({
		screen = s,
	})

	-- remove built-in tooltip.
	base_layoutbox._layoutbox_tooltip:remove_from_object(base_layoutbox)

	-- create button container
	local layoutbox = helpers.mkbtn(base_layoutbox, beautiful.black, beautiful.dimblack)

	-- function that returns the layout name but capitalized lol.
	local function layoutname()
		return helpers.capitalize(awful.layout.get(s).name)
	end

	-- make custom tooltip for the whole button
	local layoutbox_tooltip = helpers.make_popup_tooltip(layoutname(), function(d)
		return awful.placement.top_right(d, {
			margins = {
				top = beautiful.bar_height + beautiful.useless_gap * 2,
				right = beautiful.useless_gap * 2,
			},
		})
	end)

	layoutbox_tooltip.attach_to_object(layoutbox)

	-- updates tooltip content
	local update_content = function()
		layoutbox_tooltip.widget.text = layoutname()
	end

	tag.connect_signal("property::layout", update_content)
	tag.connect_signal("property::selected", update_content)

	-- layoutbox buttons
	helpers.add_buttons(layoutbox, {
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(1)
		end),
	})

	local powerbutton = helpers.mkbtn({
		image = beautiful.powerbutton_icon,
		forced_height = dpi(16),
		forced_width = dpi(16),
		halign = "center",
		valign = "center",
		widget = wibox.widget.imagebox,
	}, beautiful.black, beautiful.dimblack)

	powerbutton:add_button(awful.button({}, 1, function()
		if power_popup.visible then
			power_popup:move_next_to(mouse.current_widget_geometry)
			power_popup.visible = not power_popup.visible
		else
			power_popup:move_next_to(mouse.current_widget_geometry)
		end
	end))

	local volumebutton = helpers.mkbtn({
		image = beautiful.volume_on,
		forced_height = dpi(16),
		forced_width = dpi(16),
		halign = "center",
		valign = "center",
		widget = wibox.widget.imagebox,
	}, beautiful.black, beautiful.dimblack)

	volumebutton:add_button(awful.button({}, 1, function()
		if volume_popup.visible then
			awesome.emit_signal("widget::volume::hide")
		else
			awesome.emit_signal("widget::volume::show", true)
		end
	end))

	local systray_widget = wibox.widget({
		{
			wibox.widget.systray,
			left = 10,
			top = 2,
			bottom = 2,
			right = 10,
			forced_width = dpi(250),
			forced_height = dpi(50),
			widget = wibox.container.margin,
		},
		forced_width = dpi(250),
		forced_height = dpi(50),
		widget = wibox.container.background,
		valign = "left",
		shape_clip = true,
	})

	local systray = awful.popup({
		ontop = true,
		visible = false,
		shape = helpers.mkroundedrect(),
		bg = beautiful.bg_normal .. "af",
		widget = systray_widget,
	})
	systray:connect_signal("mouse::leave", function()
		systray.visible = false
	end)

	local systray_button = helpers.mkbtn({
		image = beautiful.menu_icon,
		forced_height = dpi(16),
		forced_width = dpi(16),
		halign = "center",
		valign = "center",
		widget = wibox.widget.imagebox,
	}, beautiful.black, beautiful.dimblack)

	systray_button:add_button(awful.button({}, 1, function()
		if systray.visible then
			systray.visible = not systray.visible
		else
			if not systray.offset then
				systray.offset = {
					y = 8,
					x = dpi(258) - awful.screen.focused().geometry.width,
				}
			else
				systray.offset.x = dpi(258) - awful.screen.focused().geometry.width
			end
			systray:move_next_to(mouse.current_widget_geometry)
		end
	end))

	local function mkcontainer(template)
		return wibox.widget({
			template,
			left = dpi(8),
			right = dpi(8),
			top = dpi(6),
			bottom = dpi(6),
			widget = wibox.container.margin,
		})
	end

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		width = s.geometry.width,
		height = beautiful.bar_height,
		shape = gears.shape.rectangle,
	})

	s.mywibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			{
				{
					mkcontainer({
						systray_button,
						taglist,
						spacing = dpi(12),
						layout = wibox.layout.fixed.horizontal,
					}),
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			nil,
			{
				mkcontainer({
					s.index == screen.primary.index and date or nil,
					layoutbox,
					s.index == screen.primary.index and volumebutton or nil,
					s.index == screen.primary.index and powerbutton or nil,
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				}),
				layout = wibox.layout.fixed.horizontal,
			},
		},
		{
			mkcontainer({
				tasklist,
				layout = wibox.layout.fixed.horizontal,
			}),
			halign = "center",
			widget = wibox.widget.margin,
			layout = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})
end)
