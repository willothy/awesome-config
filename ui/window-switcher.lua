local M = {}

local awful = Capi.awful

require("vendor.bling").widget.window_switcher.enable({
  type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews

  -- keybindings (the examples provided are also the default if kept unset)
  hide_window_switcher_key = "Escape", -- The key on which to close the popup
  minimize_key = "n", -- The key on which to minimize the selected client
  unminimize_key = "N", -- The key on which to unminimize all clients
  kill_client_key = "q", -- The key on which to close the selected client
  cycle_key = "w", -- The key on which to cycle through all clients
  previous_key = "Left", -- The key on which to select the previous client
  next_key = "Right", -- The key on which to select the next client
  vim_previous_key = "k", -- Alternative key on which to select the previous client
  vim_next_key = "j", -- Alternative key on which to select the next client

  cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
  filterClients = awful.widget.tasklist.filter.currenttags, -- The function to filter the viewed clients
})

function M.show()
  awesome.emit_signal("bling::window_switcher::turn_on")
end

return M
