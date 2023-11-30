local awful = require("awful")
local ruled = require("ruled")

local function setup_rules()
  ruled.client.connect_signal("request::rules", function()
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
    ruled.client.append_rule({
      id = "spad",
      rule_any = {
        instance = { "spad" },
      },
      properties = { titlebars_enabled = false },
    })
    ruled.client.append_rule({
      id = "titlebars",
      rule_any = { type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true },
    })
  end)

  ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule({
      rule = {},
      properties = {
        screen = awful.screen.preferred,
        implicit_timeout = 5,
      },
    })
  end)
end

setup_rules()
