local awful = Capi.awful

local modal = require("vendor.modalbind")

local volume = {
  {
    "j",
    function()
      require("lib.volume").decrease()
    end,
    "decrease",
  },
  {
    "k",
    function()
      require("lib.volume").increase()
    end,
    "increase",
  },
  {
    "m",
    function()
      require("lib.volume").mute()
    end,
    "mute",
  },
  {
    "M",
    function()
      require("lib.volume").set(1.0)
    end,
    "maximize",
  },
}

awful.keyboard.append_global_keybindings({
  -- Volume Controls
  awful.key({}, "XF86AudioRaiseVolume", function()
    require("lib.volume").increase()
  end, { description = "Raise volume", group = "media" }),
  awful.key({}, "XF86AudioLowerVolume", function()
    require("lib.volume").decrease()
  end, { description = "Lower volume", group = "media" }),
  awful.key({}, "XF86AudioMute", function()
    require("lib.volume").mute()
  end, { description = "Mute volume", group = "media" }),

  awful.key({ Settings.modkey }, "v", function()
    modal.grab({
      keymap = volume,
      name = "Volume",
      -- stay_in_mode = true,
    })
  end, { description = "Volume mode", group = "media" }),

  -- Media Controls
  awful.key({}, "XF86AudioPlay", function()
    require("lib.playerctl").play_pause()
  end, { description = "Play/pause", group = "media" }),
  awful.key({}, "XF86AudioNext", function()
    require("lib.playerctl").next()
  end, { description = "Next", group = "media" }),
  awful.key({}, "XF86AudioPrev", function()
    require("lib.playerctl").previous()
  end, { description = "Previous", group = "media" }),

  awful.key({}, "XF86MonBrightnessUp", function()
    require("lib.brightnessctl").increase()
  end, { description = "Brightness up", group = "system" }),
  awful.key({}, "XF86MonBrightnessDown", function()
    require("lib.brightnessctl").decrease()
  end, { description = "Brightness down", group = "system" }),
})
