local awful = Capi.awful
local beautiful = Capi.beautiful
local ruled = Capi.ruled

ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      -- focus = awful.client.focus.filter,
      focus = true,
      raise = true,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      titlebars_enabled = true,
    },
  })

  -- ruled.client.append_rule({
  --   id = "fullscreen_rule",
  --   rule = {
  --     fullscreen = true,
  --   },
  --   properties = {
  --     -- y = 0,
  --     honor_workarea = false,
  --     honor_padding = false,
  --     -- maximized_vertical = true,
  --     placment = function(c)
  --       return awful.placement.top(c, {
  --         honor_workarea = false,
  --         honor_padding = false,
  --         margins = {
  --           bottom = 0,
  --           top = 0,
  --           left = 0,
  --           right = 0,
  --         },
  --       })
  --     end,
  --     -- maximized_horizontal = true,
  --   },
  -- })

  -- ruled.client.append_rule({
  --   id = "fullscreen_rule",
  --   rule = {},
  --   except = {
  --     fullscreen = true,
  --   },
  --   properties = {
  --     -- honor_workarea = false,
  --     -- honor_padding = false,
  --     maximized_vertical = false,
  --     -- maximized_horizontal = true,
  --   },
  -- })

  -- Scratchpad terminal
  ruled.client.append_rule({
    id = "spad",
    rule_any = {
      instance = { "spad" },
      class = { "spad" },
    },
    properties = { titlebars_enabled = false },
  })

  ruled.client.append_rule({
    id = "mautilus",
    rule_any = {
      class = { "Nautilus" },
      instance = { "org.gnome.Nautilus" },
    },
    properties = {
      titlebars_enabled = false,
    },
  })

  ruled.client.append_rule({
    id = "picture_in_picture",
    rule_any = {
      name = {
        "Picture in picture",
        "Picture-in-Picture",
      },
    },
    properties = {
      titlebars_enabled = "toolbox",
      -- titlebars_enabled = false,
      floating = true,
      ontop = true,
      sticky = true,
      placement = function(client)
        awful.placement.top_right(client, {
          honor_workarea = true,
          margins = beautiful.useless_gap * 2,
        })
      end,
    },
  })

  -- Picture in picture

  -- Add titlebars to normal clients and dialogs
  -- ruled.client.append_rule({
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
  ruled.client.append_rule({
    id = "floating",
    rule_any = {
      instance = { "pinentry" },
      class = {
        "Arandr",
        "Pavucontrol",
        "Gnome-screenshot",
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
    properties = {
      floating = true,
      placement = awful.placement.centered,
    },
  })
end)

-- TODO: can I make this into a rule?

---@param c client
---@diagnostic disable-next-line: param-type-mismatch
client.connect_signal("property::fullscreen", function(c)
  if c.fullscreen then
    c.y = 0
  end
end)
