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
  awful.key({ Settings.modkey }, "x", function()
    require("ui.prompt").show()
    awful.prompt.run({
      prompt = "Lua: ",
      textbox = require("ui.prompt").widget.children[1],
      done_callback = function()
        require("ui.prompt").hide()
      end,
      exe_callback = function(input)
        require("ui.prompt").hide()
        if not input or #input == 0 then
          return
        end
        Capi.naughty.notify({ text = awful.util.eval(input) })
      end,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    })
  end, { description = "lua execute prompt", group = "awesome" }),
})
