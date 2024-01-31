local awful = Capi.awful

local modal = require("vendor.modalbind")

local toggle_tag = {}

for i = 1, 9 do
  table.insert(toggle_tag, {
    tostring(i),
    function()
      local tag = awful.screen.focused().tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
    "tag " .. i,
  })
end

local tags = {
  {
    "g",
    function()
      modal.grab({
        keymap = toggle_tag,
        name = "Toggle tag",
      })
    end,
    "Toggle tags",
  },
  {
    "j",
    function()
      awful.tag.viewprev()
    end,
    "Previous tag",
  },
  {
    "k",
    function()
      awful.tag.viewnext()
    end,
    "Next tag",
  },
}

for i = 1, 9 do
  table.insert(tags, {
    tostring(i),
    function()
      local tag = awful.screen.focused().tags[i]
      if tag and client.focus then
        client.focus:move_to_tag(tag)
        if #awful.screen.focused().selected_tags > 1 then
          awful.tag.viewtoggle(tag)
        else
          awful.tag.viewonly(tag)
        end
      end
    end,
    "tag " .. i,
  })
end

awful.keyboard.append_global_keybindings({
  awful.key({ Settings.modkey }, "t", function()
    modal.grab({
      keymap = tags,
      name = "Move to tag",
      -- stay_in_mode = true,
    })
  end, {
    description = "Move to tag",
    group = "tag",
  }),
  awful.key({
    modifiers = { Settings.modkey },
    keygroup = "numrow",
    description = "only view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      if not screen then
        return
      end
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  awful.key({
    modifiers = { Settings.modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      if not screen then
        return
      end
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  }),
  awful.key({
    modifiers = { Settings.modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),
  awful.key({
    modifiers = { Settings.modkey, "Control", "Shift" },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  }),
  awful.key({
    modifiers = { Settings.modkey },
    keygroup = "numpad",
    description = "select layout directly",
    group = "layout",
    on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  }),
})
