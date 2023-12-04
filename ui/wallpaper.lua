local M = {}

function M.setup()
  screen.connect_signal("request::wallpaper", function(s)
    M.set(Capi.beautiful.wallpaper, s)
  end)
end

function M.set(wallpaper, screen)
  ---@diagnostic disable-next-line: deprecated
  Capi.gears.wallpaper.maximized(wallpaper, screen, false, { x = 0, y = 0 })
end

return M
