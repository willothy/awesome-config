---@diagnostic disable:undefined-global

local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local helpers = {}

-- colorize a text using pango markup
function helpers.get_colorized_markup(content, fg)
	fg = fg or beautiful.blue
	content = content or ""

	return '<span foreground="' .. fg .. '">' .. content .. "</span>"
end

-- add hover support to wibox.container.background-based elements
function helpers.add_hover(element, bg, hbg)
	element:connect_signal("mouse::enter", function(self)
		self.bg = hbg
	end)
	element:connect_signal("mouse::leave", function(self)
		self.bg = bg
	end)
end

local rounded_corner_shape = function(radius, position)
	if position == "bottom" then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, radius)
		end
	elseif position == "top" then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, radius)
		end
	end
	return nil
end

-- create a rounded rect using a custom radius
function helpers.mkroundedrect(radius)
	radius = radius or 5
	-- local r1, r2, r3, r4 = radius, radius, radius, radius
	return function(cr, width, height)
		-- cr:new_sub_path()
		-- cr:arc(width - r1, r1, r1, rad(-90), rad(0))
		-- cr:arc(width - r2, height - r2, r2, rad(0), rad(90))
		-- cr:arc(r3, height - r3, r3, rad(90), rad(180))
		-- cr:arc(r4, r4, r4, rad(180), rad(270))
		-- cr:close_path()
		return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, radius)
	end
end

-- create a simple rounded-like button with hover support
function helpers.mkbtn(template, bg, hbg, radius)
	local button = wibox.widget({
		{
			template,
			margins = 7,
			widget = wibox.container.margin,
		},
		bg = bg,
		widget = wibox.container.background,
		shape = helpers.mkroundedrect(radius),
	})

	if bg and hbg then
		helpers.add_hover(button, bg, hbg)
	end

	return button
end

-- add a list of buttons using :add_button to `widget`.
function helpers.add_buttons(widget, buttons)
	for _, button in ipairs(buttons) do
		widget:add_button(button)
	end
end

-- trim strings
function helpers.trim(input)
	local result = input:gsub("%s+", "")
	return string.gsub(result, "%s+", "")
end

-- make a rounded container for make work the antialiasing.
function helpers.mkroundedcontainer(template, bg)
	return wibox.widget({
		template,
		shape = helpers.mkroundedrect(),
		bg = bg,
		widget = wibox.container.background,
	})
end

-- make an awful.popup that's used to replace the native AwesomeWM tooltip component
function helpers.make_popup_tooltip(text, placement)
	local ret = {}

	ret.widget = wibox.widget({
		{
			{
				id = "image",
				image = beautiful.hints_icon,
				forced_height = 12,
				forced_width = 12,
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			{
				id = "text",
				markup = text or "",
				align = "center",
				widget = wibox.widget.textbox,
			},
			spacing = 7,
			layout = wibox.layout.fixed.horizontal,
		},
		margins = 12,
		widget = wibox.container.margin,
		set_text = function(self, t)
			self:get_children_by_id("text")[1].markup = t
		end,
		set_image = function(self, i)
			self:get_children_by_id("image")[1].image = i
		end,
	})

	ret.popup = awful.popup({
		visible = false,
		shape = helpers.mkroundedrect(),
		bg = beautiful.bg_normal .. "00",
		fg = beautiful.fg_normal,
		ontop = true,
		placement = placement or awful.placement.centered,
		screen = awful.screen.focused(),
		widget = helpers.mkroundedcontainer(ret.widget, beautiful.bg_normal),
	})

	local self = ret.popup

	function ret.show()
		local screen = awful.screen.focused()
		self.screen = screen
		self.visible = true
	end

	function ret.hide()
		self.visible = false
	end

	function ret.toggle()
		if self.visible then
			self.hide()
		else
			self.show()
		end
	end

	function ret.attach_to_object(object)
		object:connect_signal("mouse::enter", ret.show)
		object:connect_signal("mouse::leave", ret.hide)
	end

	return ret
end

-- capitalize a string
function helpers.capitalize(txt)
	return string.upper(string.sub(txt, 1, 1)) .. string.sub(txt, 2, #txt)
end

-- a fully capitalizing helper.
function helpers.complex_capitalizing(s)
	local r, i = "", 0
	for w in s:gsub("-", " "):gmatch("%S+") do
		local cs = helpers.capitalize(w)
		if i == 0 then
			r = cs
		else
			r = r .. " " .. cs
		end
		i = i + 1
	end

	return r
end

-- limit a string by a length and put ... at the final if the
-- `max_length` is exceded `str`
function helpers.limit_by_length(str, max_length, use_pango)
	local sufix = ""
	local toput = "..."

	if #str > max_length - #toput then
		str = string.sub(str, 1, max_length - 3)
		sufix = toput
	end

	if use_pango and sufix == toput then
		sufix = helpers.get_colorized_markup(sufix, beautiful.light_black)
	end

	return str .. sufix
end

-- apply a margin container to a given widget
function helpers.apply_margin(widget, margins, top, bottom, right, left)
	return wibox.widget({
		widget,
		margins = margins,
		left = left,
		right = right,
		top = top,
		bottom = bottom,
		widget = wibox.container.margin,
	})
end

return helpers
