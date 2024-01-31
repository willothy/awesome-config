-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate({ context = "mouse_enter", raise = false })
end)

client.connect_signal("request::autoactivate", function(c)
  c:activate({ context = "autoactivate", raise = false })
end)

---Fix fullscreen clients not covering the entire screen due to the top bar (I think)
---@param c client
---@diagnostic disable-next-line: param-type-mismatch
client.connect_signal("property::fullscreen", function(c)
  if c.fullscreen then
    Capi.awful.placement.top(c, {
      honor_workarea = false,
      honor_padding = false,
    })
  end
end)

-- Center floating windows when they are moved to floating
---@diagnostic disable-next-line: param-type-mismatch
client.connect_signal("property::floating", function(c)
  Capi.awful.placement.centered(c, {
    honor_workarea = true,
  })
end)
