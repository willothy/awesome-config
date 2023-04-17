local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local function set_keybindings()
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
		awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
		awful.key({ modkey }, "Return", function()
			awful.spawn(terminal)
		end, { description = "open a terminal", group = "launcher" }),
		awful.key({ modkey }, "r", function()
			awful.spawn("rofi -show drun")
		end, { description = "Open rofi", group = "launcher" }),
	})

	-- Tags related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "Page_Down", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		awful.key({ modkey }, "Page_Up", awful.tag.viewnext, { description = "view next", group = "tag" }),
	})

	-- Move window binds
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, { description = "swap with next client by index", group = "client" }),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end),

		-- Direction
		awful.key({ modkey, "Shift" }, "Left", function()
			awful.client.swap.global_bydirection("left")
		end, { description = "Swap the client to the right", group = "client" }),
		awful.key({ modkey, "Shift" }, "Right", function()
			awful.client.swap.global_bydirection("right")
		end, { description = "Swap the client to the right", group = "client" }),
		awful.key({ modkey, "Shift" }, "Up", function()
			awful.client.swap.global_bydirection("up")
		end, { description = "Swap the client to the right", group = "client" }),
		awful.key({ modkey, "Shift" }, "Down", function()
			awful.client.swap.global_bydirection("down")
		end, { description = "Swap the client to the right", group = "client" }),
	})

	-- Focus related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey, "Control" }, "j", function()
			awful.screen.focus_relative(1)
		end, { description = "focus the next screen", group = "screen" }),
		awful.key({ modkey, "Control" }, "k", function()
			awful.screen.focus_relative(-1)
		end, { description = "focus the previous screen", group = "screen" }),
	})

	-- Layout related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "Tab", function()
			awful.layout.inc(1)
		end, { description = "select next", group = "layout" }),
		awful.key({ modkey, "Shift" }, "Tab", function()
			awful.layout.inc(-1)
		end, { description = "select previous", group = "layout" }),
	})

	-- Number keybinds

	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			keygroup = "numrow",
			description = "only view tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					tag:view_only()
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			keygroup = "numrow",
			description = "toggle tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			keygroup = "numrow",
			description = "move focused client to tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control", "Shift" },
			keygroup = "numrow",
			description = "toggle focused client on tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey },
			keygroup = "numpad",
			description = "select layout directly",
			group = "layout",
			on_press = function(index)
				local t = awful.screen.focused().selected_tag
				if t then
					t.layout = t.layouts[index] or t.layout
				end
			end,
		}),
	})

	-- @DOC_CLIENT_KEYBINDINGS@
	client.connect_signal("request::default_keybindings", function()
		awful.keyboard.append_client_keybindings({
			awful.key({ modkey }, "f", function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end, { description = "toggle fullscreen", group = "client" }),
			awful.key(
				{ modkey },
				"space",
				awful.client.floating.toggle,
				{ description = "toggle floating", group = "client" }
			),
			awful.key({ modkey }, "`", function(c)
				awful.client.focus.byidx(1)
				-- c:lower()
			end),
			awful.key({ modkey }, "Left", function(c)
				-- todo
				c:relative_move(0, 0, -10, 0)
			end, { description = "Move the client to the right", group = "client" }),
			awful.key({ modkey }, "Right", function(c)
				-- todo
				c:relative_move(0, 0, 10, 0)
			end, { description = "Move the client to the right", group = "client" }),
			-- awful.key({ modkey }, "o", function(c)
			-- 	c:move_to_screen()
			-- end, { description = "move to screen", group = "client" }),
			-- awful.key({ modkey }, "t", function(c)
			-- 	c.ontop = not c.ontop
			-- end, { description = "toggle keep on top", group = "client" }),
			-- awful.key({ modkey }, "n", function(c)
			-- 	-- The client currently has the input focus, so it cannot be
			-- 	-- minimized, since minimized clients can't have the focus.
			-- 	c.minimized = true
			-- end, { description = "minimize", group = "client" }),
			-- awful.key({ modkey }, "m", function(c)
			-- 	c.maximized = not c.maximized
			-- 	c:raise()
			-- end, { description = "(un)maximize", group = "client" }),
			awful.key({ modkey, "Control" }, "m", function(c)
				c.maximized_vertical = not c.maximized_vertical
				c:raise()
			end, { description = "(un)maximize vertically", group = "client" }),
			awful.key({ modkey, "Shift" }, "m", function(c)
				c.maximized_horizontal = not c.maximized_horizontal
				c:raise()
			end, { description = "(un)maximize horizontally", group = "client" }),
		})
	end)
end

set_keybindings()
