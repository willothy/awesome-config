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

local anim_x = rubato.timed({
	pos = 0,
	rate = 60,
	easing = rubato.quadratic,
	intro = 0.1,
	duration = 0.3,
	awestore_compat = true, -- This option must be set to true.
})

local term_scratch = bling.module.scratchpad({
	command = "wezterm start --class spad -- sesh attach dropdown --create", -- attach --create --name dropdown", -- How to spawn the scratchpad
	rule = { instance = "spad" }, -- The rule that the scratchpad will be searched by
	sticky = true, -- Whether the scratchpad should be sticky
	autoclose = true, -- Whether it should hide itself when losing focus
	floating = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
	geometry = { x = 0, y = 0, height = 400, width = 2560 }, -- The geometry in a floating state
	reapply = true, -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
	dont_focus_before_close = true, -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
	rubato = { y = anim_y }, -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
})

return term_scratch
