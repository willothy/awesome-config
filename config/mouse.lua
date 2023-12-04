local awful = Capi.awful

awful.mouse.append_global_mousebindings({
  awful.button({}, 1, function()
    require("ui.menu").hide()
  end),
  awful.button({}, 3, function()
    require("ui.menu").show()
  end),
  awful.button({}, 4, Capi.awful.tag.viewprev),
  awful.button({}, 5, Capi.awful.tag.viewnext),
})

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      require("ui.menu").hide()
      c:activate({ context = "mouse_click" })
    end),
    awful.button({}, 3, function(_c)
      require("ui.menu").hide()
    end),
    awful.button({ Settings.modkey }, 1, function(c)
      require("ui.menu").hide()
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ Settings.modkey }, 3, function(c)
      require("ui.menu").hide()
      c:activate({ context = "mouse_click", action = "mouse_resize" })
      -- require("lib.client").mouse_resize(c)
    end),
  })
end)
