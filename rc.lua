---@diagnostic disable: lowercase-global
pcall(require, "luarocks.loader")

-- Standard awesome libraries
local awful = require("awful")
local gears = require("gears")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

-- Declarative object management
local ruled = require("ruled")

local hotkeys_popup = require("awful.hotkeys_popup")

PROGRAMS = {
  terminal = "wezterm",
  explorer = "nautilus",
  browser = "brave",
  launcher = "rofi -show drun",
  editor = "nvim",
  visual_editor = "nvim -b",
  editor_cmd = "wezterm start nvim",
}

SETTINGS = {
  modkey = "Mod4", -- super, the windows key
}

local M = {}

function M.setup_theme()
  beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
end

-- Enable sloppy focus, so that focus follows mouse.
function M.setup_sloppy_focus()
  client.connect_signal("mouse::enter", function(c)
    c:activate({ context = "mouse_enter", raise = false })
  end)
end

function M.setup_notifications()
  ruled.notification.connect_signal("request::rules", function()
    -- All notifications will match this rule.
    ruled.notification.append_rule({
      rule = {},
      properties = {
        screen = awful.screen.preferred,
        implicit_timeout = 5,
      },
    })
  end)

  naughty.connect_signal("request::display", function(n)
    naughty.layout.box({ notification = n })
  end)
end

function M.setup_error_handling()
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
      urgency = "critical",
      title = "Oops, an error happened"
        .. (startup and " during startup!" or "!"),
      message = message,
    })
  end)
end

---Start programs that should be started automatically with awesome
function M.autostart()
  -- require("autostart")
  local conf = gears.filesystem.get_configuration_dir()

  local screens = conf .. "screens.sh"
  awful.spawn.with_shell(screens)

  -- awful.spawn("picom")
  awful.spawn("compfy")

  awful.spawn("nm-applet")
  awful.spawn.with_shell(
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  )
end

function M.register_xprops()
  -- Register xproperty for WM_CLASS so it can be set with
  -- client:set_xproperty("WM_CLASS", "class")
  awesome.register_xproperty("WM_CLASS", "string")
end

function M.setup_dependencies()
  require("revelation").init()
end

function M.setup_menu()
  myawesomemenu = {
    {
      "hotkeys",
      function()
        hotkeys_popup.show_help(nil, awful.screen.focused())
      end,
    },
    { "manual", PROGRAMS.terminal .. " -e man awesome" },
    { "edit config", PROGRAMS.editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    {
      "quit",
      function()
        awesome.quit()
      end,
    },
  }

  mymainmenu = awful.menu({
    items = {
      { "awesome", myawesomemenu, beautiful.awesome_icon },
      { "open terminal", PROGRAMS.terminal },
    },
  })
end

function M.setup_menubar()
  local menubar = require("menubar")
  -- Set the terminal for applications that require it.
  menubar.utils.terminal = PROGRAMS.terminal
end

function M.setup_floats()
  client.connect_signal("request::manage", function(c)
    awful.placement.centered(c, {
      honor_workarea = true,
    })
  end)
end

function M.setup_wallpaper()
  screen.connect_signal("request::wallpaper", function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, false, { x = 0, y = 0 })
  end)
end

function M.setup_layouts()
  tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
      awful.layout.suit.floating,
      awful.layout.suit.tile,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      awful.layout.suit.max.fullscreen,
      awful.layout.suit.magnifier,
      awful.layout.suit.corner.nw,
    })
  end)
end

function M.setup_global_keymaps()
  -- General Awesome keys
  awful.keyboard.append_global_keybindings({
    awful.key(
      { SETTINGS.modkey },
      "s",
      hotkeys_popup.show_help,
      { description = "show help", group = "awesome" }
    ),
    awful.key({ SETTINGS.modkey }, "w", function()
      mymainmenu:show()
    end, { description = "show main menu", group = "awesome" }),
    awful.key(
      { SETTINGS.modkey, "Control" },
      "r",
      awesome.restart,
      { description = "reload awesome", group = "awesome" }
    ),
    awful.key(
      { SETTINGS.modkey, "Shift" },
      "q",
      awesome.quit,
      { description = "quit awesome", group = "awesome" }
    ),
    awful.key({ SETTINGS.modkey }, "x", function()
      awful.prompt.run({
        prompt = "Run Lua code: ",
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval",
      })
    end, { description = "lua execute prompt", group = "awesome" }),
    awful.key({ SETTINGS.modkey }, "Return", function()
      awful.spawn(PROGRAMS.terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key({ SETTINGS.modkey }, "r", function()
      awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "launcher" }),
    awful.key({ SETTINGS.modkey }, "p", function()
      require("menubar").show()
    end, { description = "show the menubar", group = "launcher" }),
  })

  -- Tags related keybindings
  awful.keyboard.append_global_keybindings({
    awful.key(
      { SETTINGS.modkey },
      "Left",
      awful.tag.viewprev,
      { description = "view previous", group = "tag" }
    ),
    awful.key(
      { SETTINGS.modkey },
      "Right",
      awful.tag.viewnext,
      { description = "view next", group = "tag" }
    ),
    awful.key(
      { SETTINGS.modkey },
      "Escape",
      awful.tag.history.restore,
      { description = "go back", group = "tag" }
    ),
  })

  -- Focus related keybindings
  awful.keyboard.append_global_keybindings({
    awful.key({ SETTINGS.modkey }, "j", function()
      awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ SETTINGS.modkey }, "k", function()
      awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),
    awful.key({ SETTINGS.modkey }, "Tab", function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end, { description = "go back", group = "client" }),
    awful.key({ SETTINGS.modkey, "Control" }, "j", function()
      awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),
    awful.key({ SETTINGS.modkey, "Control" }, "k", function()
      awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    awful.key({ SETTINGS.modkey, "Control" }, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:activate({ raise = true, context = "key.unminimize" })
      end
    end, { description = "restore minimized", group = "client" }),
  })

  -- Layout related keybindings
  awful.keyboard.append_global_keybindings({
    awful.key({ SETTINGS.modkey, "Shift" }, "j", function()
      awful.client.swap.byidx(1)
    end, {
      description = "swap with next client by index",
      group = "client",
    }),
    awful.key(
      { SETTINGS.modkey, "Shift" },
      "k",
      function()
        awful.client.swap.byidx(-1)
      end,
      { description = "swap with previous client by index", group = "client" }
    ),
    awful.key(
      { SETTINGS.modkey },
      "u",
      awful.client.urgent.jumpto,
      { description = "jump to urgent client", group = "client" }
    ),
    awful.key({ SETTINGS.modkey }, "l", function()
      awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ SETTINGS.modkey }, "h", function()
      awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ SETTINGS.modkey, "Shift" }, "h", function()
      awful.tag.incnmaster(1, nil, true)
    end, {
      description = "increase the number of master clients",
      group = "layout",
    }),
    awful.key({ SETTINGS.modkey, "Shift" }, "l", function()
      awful.tag.incnmaster(-1, nil, true)
    end, {
      description = "decrease the number of master clients",
      group = "layout",
    }),
    awful.key({ SETTINGS.modkey, "Control" }, "h", function()
      awful.tag.incncol(1, nil, true)
    end, {
      description = "increase the number of columns",
      group = "layout",
    }),
    awful.key({ SETTINGS.modkey, "Control" }, "l", function()
      awful.tag.incncol(-1, nil, true)
    end, {
      description = "decrease the number of columns",
      group = "layout",
    }),
    awful.key({ SETTINGS.modkey }, "space", function()
      awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ SETTINGS.modkey, "Shift" }, "space", function()
      awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),
  })

  -- @DOC_NUMBER_KEYBINDINGS@

  awful.keyboard.append_global_keybindings({
    awful.key({
      modifiers = { SETTINGS.modkey },
      keygroup = "numrow",
      description = "only view tag",
      group = "tag",
      on_press = function(index)
        local screen = awful.screen.focused()
        if not screen then
          return
        end
        local tag = screen.tags[index]
        if tag then
          tag:view_only()
        end
      end,
    }),
    awful.key({
      modifiers = { SETTINGS.modkey, "Control" },
      keygroup = "numrow",
      description = "toggle tag",
      group = "tag",
      on_press = function(index)
        local screen = awful.screen.focused()
        if not screen then
          return
        end
        local tag = screen.tags[index]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
    }),
    awful.key({
      modifiers = { SETTINGS.modkey, "Shift" },
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
      modifiers = { SETTINGS.modkey, "Control", "Shift" },
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
      modifiers = { SETTINGS.modkey },
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
end

function M.setup_global_mouse_bindings()
  awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function()
      mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
  })
end

function M.setup_client_keymaps()
  client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
      awful.key({ SETTINGS.modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end, { description = "toggle fullscreen", group = "client" }),
      awful.key({ SETTINGS.modkey, "Shift" }, "c", function(c)
        c:kill()
      end, { description = "close", group = "client" }),
      awful.key(
        { SETTINGS.modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
      ),
      awful.key({ SETTINGS.modkey, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
      end, { description = "move to master", group = "client" }),
      awful.key({ SETTINGS.modkey }, "o", function(c)
        c:move_to_screen()
      end, { description = "move to screen", group = "client" }),
      awful.key({ SETTINGS.modkey }, "t", function(c)
        c.ontop = not c.ontop
      end, { description = "toggle keep on top", group = "client" }),
      awful.key({ SETTINGS.modkey }, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end, { description = "minimize", group = "client" }),
      awful.key({ SETTINGS.modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
      end, { description = "(un)maximize", group = "client" }),
      awful.key({ SETTINGS.modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end, { description = "(un)maximize vertically", group = "client" }),
      awful.key({ SETTINGS.modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end, { description = "(un)maximize horizontally", group = "client" }),
    })
  end)
end

function M.setup_client_mouse_bindings()
  client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
      awful.button({}, 1, function(c)
        c:activate({ context = "mouse_click" })
      end),
      awful.button({ SETTINGS.modkey }, 1, function(c)
        c:activate({ context = "mouse_click", action = "mouse_move" })
      end),
      awful.button({ SETTINGS.modkey }, 3, function(c)
        c:activate({ context = "mouse_click", action = "mouse_resize" })
      end),
    })
  end)
end

function M.setup_topbar()
  screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag(
      { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
      s,
      awful.layout.layouts[1]
    )

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox({
      screen = s,
      buttons = {
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
      },
    })

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = {
        awful.button({}, 1, function(t)
          t:view_only()
        end),
        awful.button({ SETTINGS.modkey }, 1, function(t)
          if client.focus then
            client.focus:move_to_tag(t)
          end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ SETTINGS.modkey }, 3, function(t)
          if client.focus then
            client.focus:toggle_tag(t)
          end
        end),
        awful.button({}, 4, function(t)
          awful.tag.viewprev(t.screen)
        end),
        awful.button({}, 5, function(t)
          awful.tag.viewnext(t.screen)
        end),
      },
    })

    -- @TASKLIST_BUTTON@
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = {
        awful.button({}, 1, function(c)
          c:activate({ context = "tasklist", action = "toggle_minimization" })
        end),
        awful.button({}, 3, function()
          awful.menu.client_list({ theme = { width = 250 } })
        end),
        awful.button({}, 4, function()
          awful.client.focus.byidx(-1)
        end),
        awful.button({}, 5, function()
          awful.client.focus.byidx(1)
        end),
      },
    })

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = awful.wibar({
      position = "top",
      screen = s,
      -- @DOC_SETUP_WIDGETS@
      widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          s.mytaglist,
          s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          wibox.widget.systray(),
          s.mylayoutbox,
        },
      },
    })
  end)
end

function M.setup_rules()
  ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule({
      id = "global",
      rule = {},
      properties = {
        focus = awful.client.focus.filter,
        raise = true,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      },
    })

    -- Scratchpad terminal
    ruled.client.append_rule({
      id = "spad",
      rule_any = { instance = { "spad" } },
      properties = { titlebars_enabled = false },
    })

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule({
      id = "titlebars",
      rule_any = { type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true },
    })

    -- Floating clients
    ruled.client.append_rule({
      id = "floating",
      rule_any = {
        instance = { "pinentry" },
        class = {
          "Arandr",
        },
        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester", -- xev.
        },
        role = {
          "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        },
      },
      properties = { floating = true },
    })
  end)
end

function M.setup_titlebars()
  client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
      awful.button({}, 1, function()
        c:activate({ context = "titlebar", action = "mouse_move" })
      end),
      awful.button({}, 3, function()
        c:activate({ context = "titlebar", action = "mouse_resize" })
      end),
    }

    awful.titlebar(c).widget = {
      { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal,
      },
      { -- Middle
        { -- Title
          halign = "center",
          widget = awful.titlebar.widget.titlewidget(c),
        },
        buttons = buttons,
        layout = wibox.layout.flex.horizontal,
      },
      { -- Right
        awful.titlebar.widget.floatingbutton(c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton(c),
        awful.titlebar.widget.ontopbutton(c),
        awful.titlebar.widget.closebutton(c),
        layout = wibox.layout.fixed.horizontal(),
      },
      layout = wibox.layout.align.horizontal,
    }
  end)
end

-- Pre-init steps
M.register_xprops()

-- Basic initialization steps
M.setup_error_handling()
M.setup_theme()
M.setup_notifications()
M.setup_sloppy_focus()
M.setup_floats()
M.setup_wallpaper()

-- Setup for plugins, libraries, etc.
M.setup_dependencies()

-- Menu setup
M.setup_menu()

M.setup_menubar()

M.setup_topbar()

-- Layout setup
M.setup_layouts()

M.setup_titlebars()

-- Rules
M.setup_rules()

-- Mappings
M.setup_global_keymaps()
M.setup_global_mouse_bindings()

M.setup_client_keymaps()
M.setup_client_mouse_bindings()

-- Environment setup
M.autostart()

-- require("signal.global")
-- require("configuration")
-- require("ui")
