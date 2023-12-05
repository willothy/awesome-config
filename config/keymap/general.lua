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

    -- local prompt_icon = Capi.wibox.container.margin({
    --   -- "󰢱 "
    --   {},
    --   markup = "<span foreground='#ffffff'>󰢱</span>",
    -- })
    --
    -- local prompt_icon = Capi.wibox.widget({
    --   {
    --     widget = prompt_icon,
    --   },
    --   layout = Capi.wibox.layout.fixed.horizontal,
    --   -- widget = prompt_icon,
    -- })

    awful.prompt.run({
      prompt = "󰢱 ",
      font = "Fira Code NF 12",
      textbox = require("ui.prompt").widget,
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
