local awful = require('awful')
local ruled = require("ruled")
local modkey = require('configuration.keys.mod').modKey

local clientButtons = {
    awful.button({ }, 1, function (c)
        c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function (c)
        c:activate { context = "mouse_click", action = "mouse_move"  }
    end),
    awful.button({  }, 3, function (c)
        if c.isPopup then
            c:activate { context = "mouse_click", action = "mouse_move"  }
            return
        end
    end),
    awful.button({ modkey }, 3, function (c)
        c:activate { context = "mouse_click", action = "mouse_resize"}
    end),
}
return clientButtons