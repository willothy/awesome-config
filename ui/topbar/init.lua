local M = {}

local awful = Capi.awful
local beautiful = Capi.beautiful
local wibox = Capi.wibox

function M.setup()
  screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag(
      { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
      s,
      awful.layout.layouts[1]
    )

    -- local taglist = require("ui.topbar.taglist")

    -- prompt_popup:show()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = Capi.awful.widget.layoutbox({
      screen = s,
      buttons = {
        Capi.awful.button({}, 1, function()
          Capi.awful.layout.inc(1)
        end),
        Capi.awful.button({}, 3, function()
          Capi.awful.layout.inc(-1)
        end),
        Capi.awful.button({}, 4, function()
          Capi.awful.layout.inc(-1)
        end),
        Capi.awful.button({}, 5, function()
          Capi.awful.layout.inc(1)
        end),
      },
    })

    -- Create a taglist widget
    s.mytaglist = Capi.awful.widget.taglist({
      screen = s,
      filter = Capi.awful.widget.taglist.filter.all,
      buttons = {
        Capi.awful.button({}, 1, function(t)
          t:view_only()
        end),
        Capi.awful.button({ Settings.modkey }, 1, function(t)
          if client.focus then
            client.focus:move_to_tag(t)
          end
        end),
        Capi.awful.button({}, 3, Capi.awful.tag.viewtoggle),
        Capi.awful.button({ Settings.modkey }, 3, function(t)
          if client.focus then
            client.focus:toggle_tag(t)
          end
        end),
        Capi.awful.button({}, 4, function(t)
          Capi.awful.tag.viewprev(t.screen)
        end),
        Capi.awful.button({}, 5, function(t)
          Capi.awful.tag.viewnext(t.screen)
        end),
      },
    })

    -- @TASKLIST_BUTTON@
    -- Create a tasklist widget
    s.mytasklist = Capi.awful.widget.tasklist({
      screen = s,
      filter = Capi.awful.widget.tasklist.filter.currenttags,
      buttons = {
        Capi.awful.button({}, 1, function(c)
          c:activate({ context = "tasklist", action = "toggle_minimization" })
        end),
        Capi.awful.button({}, 3, function()
          Capi.awful.menu.client_list({ theme = { width = 250 } })
        end),
        Capi.awful.button({}, 4, function()
          Capi.awful.client.focus.byidx(-1)
        end),
        Capi.awful.button({}, 5, function()
          Capi.awful.client.focus.byidx(1)
        end),
      },
    })

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = Capi.awful.wibar({
      position = "top",
      screen = s,
      -- @DOC_SETUP_WIDGETS@
      widget = {
        layout = Capi.wibox.layout.align.horizontal,
        { -- Left widgets
          layout = Capi.wibox.layout.fixed.horizontal,
          s.mytaglist,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = Capi.wibox.layout.fixed.horizontal,
          Capi.wibox.widget.systray(),
          s.mylayoutbox,
        },
      },
    })
  end)
end

return M
