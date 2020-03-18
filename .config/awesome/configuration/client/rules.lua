local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local client_keys = require("configuration.client.keys")
local client_buttons = require("configuration.client.buttons")

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
      rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = client_keys,
        buttons = client_buttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
     },
    },
    -- Floating clients.
    {
      rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "Nvidia-settings",
          "Pavucontrol",
          "Org.gnome.Nautilus",
          "Gnome-system-monitor"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
        }
      },
      properties = {
        floating = true,
        skip_decoration = true,
        placement = awful.placement.centered
      }
    },
    --Popups and Picture in pictures rules
    {
      rule_any = {
        instance = {
          "Toolkit"
        },
        name = {
          "Picture in picture",
          "Picture-in-Picture",
          "Picture-in-picture",
        },
        role = {
          "pop-up",
          "PictureInPicture"
        }
      },
      properties = {
        floating = true,
        skip_decoration = true,
        ontop = true,
        sticky = true
      }
    },
    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "dialog" }},
      properties = {
        titlebars_enabled = false,
        placement = awful.placement.centered,
        ontop = true,
        floating = true,
        shape = function()
          return function(cr,w,h)
            gears.shape.rounded_rect(cr, w, h, 8)
          end
        end,
        skip_decoration = true,
       }
    },

    {
      rule_any = {
        type = {
          "dock",
          "utility",
          "toolbar"
        },
      },
        properties = {
          skip_decoration = true,
          border_width = 0,
          shape = function()
            return function (cr,w,h)
              gears.shape.rectangle(cr,w,h)
            end
          end
      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}