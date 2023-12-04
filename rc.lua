---@diagnostic disable: lowercase-global
pcall(require, "luarocks.loader")

Capi = {
  -- Standard awesome libraries
  awful = require("awful"),
  gears = require("gears"),

  -- Widget and layout library
  wibox = require("wibox"),

  -- Theme handling library
  beautiful = require("beautiful"),

  -- Notification library
  naughty = require("naughty"),

  -- Declarative object management
  ruled = require("ruled"),

  hotkeys_popup = require("awful.hotkeys_popup"),
}

Programs = {
  terminal = "wezterm",
  explorer = "nautilus",
  browser = "brave",
  launcher = "rofi -show drun",
  editor = "nvim",
  visual_editor = "nvim -b",
  editor_cmd = "wezterm start -- nvim",
}

Settings = {
  modkey = "Mod4", -- super, the windows key or the command key
}

local M = {}

function M.setup_theme()
  Capi.beautiful.init(require("config.theme"))
end

-- Enable sloppy focus, so that focus follows mouse.
function M.setup_sloppy_focus()
  client.connect_signal("mouse::enter", function(c)
    c:activate({ context = "mouse_enter", raise = false })
  end)
end

function M.setup_notifications()
  Capi.ruled.notification.connect_signal("request::rules", function()
    -- All notifications will match this rule.
    Capi.ruled.notification.append_rule({
      rule = {},
      properties = {
        screen = Capi.awful.screen.preferred,
        implicit_timeout = 5,
      },
    })
  end)

  Capi.naughty.connect_signal("request::display", function(n)
    Capi.naughty.layout.box({ notification = n })
  end)
end

function M.setup_error_handling()
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  Capi.naughty.connect_signal(
    "request::display_error",
    function(message, startup)
      Capi.naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened"
          .. (startup and " during startup!" or "!"),
        message = message,
      })
    end
  )
end

---Start programs that should be started automatically with awesome
function M.autostart()
  -- require("autostart")
  local conf = Capi.gears.filesystem.get_configuration_dir()

  local screens = conf .. "screens.sh"
  Capi.awful.spawn.with_shell(screens)

  -- awful.spawn("picom")
  Capi.awful.spawn("compfy")

  Capi.awful.spawn("nm-applet")
  Capi.awful.spawn.with_shell(
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  )
end

function M.register_xprops()
  -- Register xproperty for WM_CLASS so it can be set with
  -- client:set_xproperty("WM_CLASS", "class")
  awesome.register_xproperty("WM_CLASS", "string")
end

function M.setup_dependencies()
  require("lib.revelation").init()
end

function M.setup_menubar()
  local menubar = require("menubar")
  -- Set the terminal for applications that require it.
  menubar.utils.terminal = Programs.terminal
end

function M.setup_floats()
  client.connect_signal("request::manage", function(c)
    Capi.awful.placement.centered(c, {
      honor_workarea = true,
    })
  end)
end

function M.setup_layouts()
  tag.connect_signal("request::default_layouts", function()
    Capi.awful.layout.append_default_layouts({
      Capi.awful.layout.suit.tile,
      -- Capi.awful.layout.suit.floating,
      Capi.awful.layout.suit.tile.left,
      Capi.awful.layout.suit.tile.bottom,
      Capi.awful.layout.suit.tile.top,
      Capi.awful.layout.suit.fair,
      Capi.awful.layout.suit.fair.horizontal,
      Capi.awful.layout.suit.spiral,
      Capi.awful.layout.suit.spiral.dwindle,
      Capi.awful.layout.suit.max,
      Capi.awful.layout.suit.max.fullscreen,
      Capi.awful.layout.suit.magnifier,
      Capi.awful.layout.suit.corner.nw,
    })
  end)
end

function M.setup_mappings()
  require("config.mouse")
  require("config.keymap")
end

function M.setup_topbar()
  screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    Capi.awful.tag(
      { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
      s,
      Capi.awful.layout.layouts[1]
    )

    -- Create a promptbox for each screen
    s.mypromptbox = Capi.awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = Capi.awful.widget.layoutbox({
      screen = s,
      buttons = {
        Capi.awful.button({}, 1, function()
          Capi.awful.layout.inc(1)
        end),
        Capi.awful.button({}, 3, function()
          Capi.awful.layout.inc(-1)
        end),
        Capi.awful.button({}, 4, function()
          Capi.awful.layout.inc(-1)
        end),
        Capi.awful.button({}, 5, function()
          Capi.awful.layout.inc(1)
        end),
      },
    })

    -- Create a taglist widget
    s.mytaglist = Capi.awful.widget.taglist({
      screen = s,
      filter = Capi.awful.widget.taglist.filter.all,
      buttons = {
        Capi.awful.button({}, 1, function(t)
          t:view_only()
        end),
        Capi.awful.button({ Settings.modkey }, 1, function(t)
          if client.focus then
            client.focus:move_to_tag(t)
          end
        end),
        Capi.awful.button({}, 3, Capi.awful.tag.viewtoggle),
        Capi.awful.button({ Settings.modkey }, 3, function(t)
          if client.focus then
            client.focus:toggle_tag(t)
          end
        end),
        Capi.awful.button({}, 4, function(t)
          Capi.awful.tag.viewprev(t.screen)
        end),
        Capi.awful.button({}, 5, function(t)
          Capi.awful.tag.viewnext(t.screen)
        end),
      },
    })

    -- @TASKLIST_BUTTON@
    -- Create a tasklist widget
    s.mytasklist = Capi.awful.widget.tasklist({
      screen = s,
      filter = Capi.awful.widget.tasklist.filter.currenttags,
      buttons = {
        Capi.awful.button({}, 1, function(c)
          c:activate({ context = "tasklist", action = "toggle_minimization" })
        end),
        Capi.awful.button({}, 3, function()
          Capi.awful.menu.client_list({ theme = { width = 250 } })
        end),
        Capi.awful.button({}, 4, function()
          Capi.awful.client.focus.byidx(-1)
        end),
        Capi.awful.button({}, 5, function()
          Capi.awful.client.focus.byidx(1)
        end),
      },
    })

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = Capi.awful.wibar({
      position = "top",
      screen = s,
      -- @DOC_SETUP_WIDGETS@
      widget = {
        layout = Capi.wibox.layout.align.horizontal,
        { -- Left widgets
          layout = Capi.wibox.layout.fixed.horizontal,
          s.mytaglist,
          s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = Capi.wibox.layout.fixed.horizontal,
          Capi.wibox.widget.systray(),
          s.mylayoutbox,
        },
      },
    })
  end)
end

function M.setup_titlebars()
  client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
      Capi.awful.button({}, 1, function()
        c:activate({ context = "titlebar", action = "mouse_move" })
      end),
      Capi.awful.button({}, 3, function()
        c:activate({ context = "titlebar", action = "mouse_resize" })
      end),
    }

    Capi.awful.titlebar(c).widget = {
      { -- Left
        Capi.awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout = Capi.wibox.layout.fixed.horizontal,
      },
      { -- Middle
        { -- Title
          halign = "center",
          widget = Capi.awful.titlebar.widget.titlewidget(c),
        },
        buttons = buttons,
        layout = Capi.wibox.layout.flex.horizontal,
      },
      { -- Right
        Capi.awful.titlebar.widget.floatingbutton(c),
        Capi.awful.titlebar.widget.maximizedbutton(c),
        Capi.awful.titlebar.widget.stickybutton(c),
        Capi.awful.titlebar.widget.ontopbutton(c),
        Capi.awful.titlebar.widget.closebutton(c),
        layout = Capi.wibox.layout.fixed.horizontal(),
      },
      layout = Capi.wibox.layout.align.horizontal,
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

-- Setup for plugins, libraries, etc.
M.setup_dependencies()

-- Layout setup
M.setup_layouts()

-- Rules
require("config.rules")

-- Mappings
require("config.mouse")
require("config.keymap")

-- UI Setup
require("ui.wallpaper").setup()

require("ui.menu").setup()

M.setup_menubar()

M.setup_topbar()

M.setup_titlebars()
-- End UI setup

-- Environment setup
M.autostart()

-- require("signal.global")
-- require("configuration")
-- require("ui")
