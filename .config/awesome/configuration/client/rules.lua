local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local ruled = require("ruled")

local client_keys = require("configuration.client.keys")
local client_buttons = require("configuration.client.buttons")


ruled.client.connect_signal('request::rules', function ()
  -- All clients will match this rule.
  ruled.client.append_rule {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.centered,
      shape = function(cr,w,h)
        gears.shape.rounded_rect(cr, w, h, 4)
      end,
   },
  }
 -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id = "titlebars",
    rule_any = {type = {"normal", "dialog"}},
    except_any = {
      instance = {
        "gnome-",
        "org.gnome.",
        "code - insiders",
        "code",
        "vivaldi-snapshot",
        "lollypop",
        "chromium",
        "eog",
        "gedit",
		    "Navigator"
      }
    },
    properties = {titlebars_enabled = true}
  }
-- Popups and Picture in pictures rules
  ruled.client.append_rule {
    id = 'popup',
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
      titlebars_enabled = false,
      floating = true,
      skip_decoration = true,
      ontop = true,
      sticky = true,
      shape = function (cr,w,h)
          gears.shape.rounded_rect(cr,w,h,4)
      end
    },
    -- Setting position and size for picture-in-picture clients
    callback = function (c)
      c.isPopup = true
      if c.instance == "Toolkit" then
        -- c.width = c.width - (c.width * 0.35)
        -- c.height = c.height - (c.height * 0.35)
      end
      c.x = c.screen.geometry.width - c.width - dpi(7)
      c.y = c.screen.geometry.height - c.height - dpi(30)
    end
  }
   -- Dialog clients
  ruled.client.append_rule {
    rule_any = {type = { "dialog" }},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      shape = function(cr,w,h)
        gears.shape.rounded_rect(cr, w, h, 4)
      end,
      skip_decoration = true,
    }
  }
  ruled.client.append_rule {
    rule_any = {
      type = {
        "dock",
        "utility",
        "toolbar"
      },
    },
    except_any = {
      instance = {'Toolkit'}
    },
    properties = {
      skip_decoration = true,
      border_width = 0,
      shape = function(cr,w,h)
        gears.shape.rectangle(cr,w,h)
      end
    },
    callback = function (c)
      if c.instance ~= 'vlc' then return end
      c.y = c.screen.geometry.height - c.height
      c.shape = function (cr, w, h)
        gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 5)
      end
    end
  }
  -- Maximized clients
  ruled.client.append_rule {
    rule_any = {
      maximized = {true},
    },
    properties = {
      y = 0,
      shape = gears.shape.rectangle
    },
    callback = function (c)
      c.height = c.screen.geometry.height - beautiful.top_panel_height
    end
  }

end)
local function handleCorners(client)
  if client.maximized or client.fullscreen then
    client.shape = gears.shape.rectangle
  else
    client.shape = function (cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 4)
    end
  end
end
_G.client.connect_signal('property::maximized', handleCorners)
_G.client.connect_signal('property::fullscreen', handleCorners)