local bling = require("bling")
local rubato = require("rubato") -- Totally optional, only required if you are using animations.

-- These are example rubato tables. You can use one for just y, just x, or both.
-- The duration and easing is up to you. Please check out the rubato docs to learn more.
local anim_y = rubato.timed({
  pos = -400,
  rate = 60,
  easing = rubato.quadratic,
  intro = 0.1,
  duration = 0.3,
  awestore_compat = true, -- This option must be set to true.
})

local term_scratch = bling.module.scratchpad({
  command = "wezterm start --class spad", -- attach --create --name dropdown", -- How to spawn the scratchpad
  rule = { instance = "spad" }, -- The rule that the scratchpad will be searched by
  sticky = true, -- Whether the scratchpad should be sticky
  autoclose = true, -- Whether it should hide itself when losing focus
  floating = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
  geometry = { x = 0, y = 0, height = 400, width = 2560 }, -- The geometry in a floating state
  reapply = true, -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
  dont_focus_before_close = false, -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
  rubato = { y = anim_y }, -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
})

-- Override the default behavior of the scratchpad to center it on the primary screen instead
-- of the focused one.
function term_scratch:apply(c)
  if not c or not c.valid then
    return
  end
  c.floating = self.floating
  c.sticky = self.sticky
  c.fullscreen = false
  c.maximized = false
  c:geometry({
    x = self.geometry.x + screen.primary.geometry.x,
    y = self.geometry.y + screen.primary.geometry.y,
    width = self.geometry.width,
    height = self.geometry.height,
  })

  if self.autoclose then
    c:connect_signal("unfocus", function(c1)
      c1.sticky = false -- client won't turn off if sticky
      bling.helpers.client.turn_off(c1)
    end)
  end
end

local M = {}

M.toggle = function()
  term_scratch:toggle()
end

return M
