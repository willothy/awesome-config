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
  Capi.awful.spawn("nm-applet")
  Capi.awful.spawn.with_shell(
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  )
end

function M.setup_screens()
  local screens = Capi.gears.filesystem.get_configuration_dir() .. "screens.sh"
  Capi.awful.spawn.with_shell(screens)
end

function M.setup_compositor()
  -- awful.spawn("picom")
  Capi.awful.spawn("compfy")
end

function M.register_xprops()
  -- Register xproperty for WM_CLASS so it can be set with
  -- client:set_xproperty("WM_CLASS", "class")
  awesome.register_xproperty("WM_CLASS", "string")
end

function M.setup_dependencies()
  require("lib.revelation").init()
end

function M.setup_floats()
  client.connect_signal("request::manage", function(c)
    Capi.awful.placement.centered(c, {
      honor_workarea = true,
    })
  end)
end

-- Pre-init steps
M.setup_error_handling()
M.setup_screens()
M.register_xprops()
M.setup_compositor()

-- Basic initialization steps
M.setup_theme()
M.setup_sloppy_focus()
M.setup_floats()

-- Setup for plugins, libraries, etc.
M.setup_dependencies()

-- Layout setup
require("config.layouts").setup()

-- Rules
require("config.rules")

-- Mappings
require("config.mouse")
require("config.keymap")

-- UI Setup
require("ui.wallpaper").setup()
require("ui.notifications").setup()
require("ui.menu").setup()
require("ui.window-switcher").setup()

require("ui.titlebar").setup()
require("ui.topbar").setup()

-- Compositor and Environment setup
M.autostart()

-- require("signal.global")
-- require("configuration")
-- require("ui")
