local awful = Capi.awful

awful.keyboard.append_global_keybindings({
  -- Launcher
  awful.key({ Settings.modkey }, "r", function()
    awful.spawn("rofi -show drun")
  end, { description = "rofi", group = "launcher" }),
  awful.key({ Settings.modkey }, "p", function()
    require("menubar").show()
  end, { description = "show the menubar", group = "launcher" }),
  awful.key({}, "XF86LaunchA", function()
    require("revelation")()
  end, { description = "Reveal", group = "launcher" }),
  -- awful.key({}, "XF86LaunchB", function()
  --   --
  -- end, { description = "Reveal", group = "launcher" }),

  -- Terminal
  awful.key({ Settings.modkey }, "Return", function()
    awful.spawn(Programs.terminal)
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ Settings.modkey }, "KP_Enter", function()
    -- TODO: Open scratchpad terminal
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ "Mod1" }, "Tab", function()
    -- TODO: Open window switcher
    -- awesome.emit_signal("bling::window_switcher::turn_on")
  end, { description = "Window Switcher", group = "bling" }),
})