local awful = Capi.awful

awful.keyboard.append_global_keybindings({
  -- Swap windows
  -- Left
  awful.key({ Settings.modkey, "Shift" }, "Left", function()
    awful.client.swap.global_bydirection("left")
  end, { description = "Swap with the client to the left", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "h", function()
    awful.client.swap.global_bydirection("left")
  end, { description = "Swap with the client to the left", group = "layout" }),

  -- Right
  awful.key({ Settings.modkey, "Shift" }, "Right", function()
    awful.client.swap.global_bydirection("right")
  end, { description = "Swap with the client to the right", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "l", function()
    awful.client.swap.global_bydirection("right")
  end, { description = "Swap with the client to the right", group = "layout" }),

  -- Up
  awful.key({ Settings.modkey, "Shift" }, "Up", function()
    awful.client.swap.global_bydirection("up")
  end, { description = "Swap with the client above", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "k", function()
    awful.client.swap.global_bydirection("up")
  end, { description = "Swap with the client above", group = "layout" }),

  -- Down
  awful.key({ Settings.modkey, "Shift" }, "Down", function()
    awful.client.swap.global_bydirection("down")
  end, { description = "Swap with the client below", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "j", function()
    awful.client.swap.global_bydirection("down")
  end, { description = "Swap with the client below", group = "layout" }),

  -- Focus windows
  -- Up
  awful.key({ Settings.modkey }, "Up", function()
    awful.client.focus.global_bydirection("up")
  end, { description = "Focus the client above", group = "layout" }),
  awful.key({ Settings.modkey }, "k", function()
    awful.client.focus.global_bydirection("up")
  end, { description = "Focus the client above", group = "layout" }),

  -- Down
  awful.key({ Settings.modkey }, "Down", function()
    awful.client.focus.global_bydirection("down")
  end, { description = "Focus the client below", group = "layout" }),
  awful.key({ Settings.modkey }, "j", function()
    awful.client.focus.global_bydirection("down")
  end, { description = "Focus the client below", group = "layout" }),

  -- Left
  awful.key({ Settings.modkey }, "Left", function()
    awful.client.focus.global_bydirection("left")
  end, { description = "Focus the client to the left", group = "layout" }),
  awful.key({ Settings.modkey }, "h", function()
    awful.client.focus.global_bydirection("left")
  end, { description = "Focus the client to the left", group = "layout" }),

  -- Right
  awful.key({ Settings.modkey }, "Right", function()
    awful.client.focus.global_bydirection("right")
  end, { description = "Focus the client to the right", group = "layout" }),
  awful.key({ Settings.modkey }, "l", function()
    awful.client.focus.global_bydirection("right")
  end, { description = "Focus the client to the right", group = "layout" }),

  -- Focus screens
  awful.key({ Settings.modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
    -- awful.focus.byidx(1)
  end, { description = "focus the next screen", group = "layout" }),
  awful.key({ Settings.modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
    -- awful.focus.byidx(-1)
  end, { description = "focus the previous screen", group = "layout" }),

  -- Layout
  awful.key({ Settings.modkey }, "`", function()
    awful.layout.inc(1)
  end, { description = "next layout", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "`", function()
    awful.layout.inc(-1)
  end, { description = "previous layout", group = "layout" }),
})

awful.keyboard.append_client_keybindings({
  awful.key({ Settings.modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    if c.fullscreen then
      c:raise()
    end
  end, {
    description = "toggle fullscreen",
    group = "layout",
  }),
  awful.key({ Settings.modkey }, "Space", function(c)
    c.floating = not c.floating
    if c.floating then
      c:raise()
    end
  end, {
    description = "toggle floating",
    group = "layout",
  }),
  Capi.awful.key({ Settings.modkey, "Shift" }, "c", function(c)
    c:kill()
  end, { description = "close window", group = "layout" }),
})
