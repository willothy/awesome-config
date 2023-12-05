local M = {}

function M.notify(title, msg, timeout)
  -- TODO
  Capi.naughty.notify({
    title = title,
    text = msg,
    timeout = timeout,
  })
end

function M.setup()
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

return M
