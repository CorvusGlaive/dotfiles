local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


local mytextclock = wibox.widget.textclock('<span font="Rubik Medium 10">%a %b %d, </span> <span font="Rubik Bold 11">%H:%M</span>')
local month_calendar = awful.widget.calendar_popup.month {
    -- long_weekdays = true,
    bg = beautiful.top_panel_bg,
    font = "Rubik Medium 10",
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
        border_width = 0,
    },
}
month_calendar:attach( mytextclock, "tc")


return mytextclock