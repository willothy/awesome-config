local awful = require("awful")

awful.keyboard.append_global_keybindings({
  awful.key(
    { Settings.modkey },
    "s",
    Capi.hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }
  ),
  awful.key(
    { Settings.modkey, "Control" },
    "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  awful.key(
    { Settings.modkey, "Shift" },
    "q",
    awesome.quit,
    { description = "quit awesome", group = "awesome" }
  ),
  -- -- TODO: Rework input prompt
  awful.key({ Settings.modkey }, "x", function()
    awful.prompt.run({
      prompt = "Lua: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    })
  end, { description = "lua execute prompt", group = "awesome" }),
})
