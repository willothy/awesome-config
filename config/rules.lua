Capi.ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  Capi.ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      -- focus = Capi.awful.client.focus.filter,
      focus = true,
      raise = true,
      screen = Capi.awful.screen.preferred,
      placement = Capi.awful.placement.no_overlap
        + Capi.awful.placement.no_offscreen,
      titlebars_enabled = true,
    },
  })

  -- Scratchpad terminal
  Capi.ruled.client.append_rule({
    id = "spad",
    rule_any = {
      instance = { "spad" },
      class = { "spad" },
    },
    properties = { titlebars_enabled = false },
  })

  Capi.ruled.client.append_rule({
    id = "mautilus",
    rule_any = {
      class = { "Nautilus" },
      instance = { "org.gnome.Nautilus" },
    },
    properties = {
      titlebars_enabled = false,
    },
  })

  -- Add titlebars to normal clients and dialogs
  -- Capi.ruled.client.append_rule({
  --   id = "titlebars",
  --   rule_any = {
  --     type = { "normal", "dialog" },
  --     except = {
  --       properties = {
  --         titlebars_enabled = false,
  --       },
  --     },
  --   },
  --   properties = { titlebars_enabled = true },
  -- })

  -- Floating clients
  Capi.ruled.client.append_rule({
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
