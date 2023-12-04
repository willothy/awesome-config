local M = {}

local awful = Capi.awful

function M.play()
  awful.spawn.with_shell("playerctl play")
end

function M.pause()
  awful.spawn.with_shell("playerctl pause")
end

function M.stop()
  awful.spawn.with_shell("playerctl stop")
end

function M.play_pause()
  awful.spawn.with_shell("playerctl play-pause")
end

function M.next()
  awful.spawn.with_shell("playerctl next")
end

function M.previous()
  awful.spawn.with_shell("playerctl previous")
end

return M
