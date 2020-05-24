local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local app_launcher = wibox.widget {
    widget = require("widget.clickable-container"),
    {
        widget = wibox.container.margin,
        margins = {
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(4),
            right = dpi(4),
        },
        {
            widget = wibox.widget.imagebox,
            image = require('beautiful').titlebar_floating_button_focus_inactive
        }
    },
}
app_launcher:buttons(
    gears.table.join(
        awful.button({},1,nil,function() 
            awful.spawn(require('configuration.apps').default.rofi .. " -theme " 
            .. ".config/awesome/configuration/rofi.rasi",false)
        end)
    )
)
return app_launcher