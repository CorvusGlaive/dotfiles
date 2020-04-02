local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


local mytextclock = wibox.widget.textclock('%a %b %d, <b>%H:%M</b>')
mytextclock.font = 'SF Pro Display 11'
local month_calendar = awful.widget.calendar_popup.month {
    -- long_weekdays = true,
    bg = beautiful.top_panel_bg,
    font = 'Inter SemiBold 10',
    style_month = {
        bg_color = "#00000000",
        border_width = 0,
        padding = 14,
    },
    style_header = {
        border_width = 0,
        bg_color = "#00000000",
    },
    style_weekday = {
        border_width = 0,
        bg_color = "#00000000",
    },
    style_normal = {
        bg_color = "#00000000",
        border_width = 0,
    },
    style_focus = {
        bg_color = "#408cdd",
        border_width = 0,
        markup = function(t) return t end,
        shape = function(cr,w,h)
              gears.shape.rounded_rect(cr, w, h, 4)
          end,
        padding = dpi(3)
    },
}
month_calendar:attach( mytextclock, "tc")


return mytextclock