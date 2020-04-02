local awful = require("awful")
local wibox = require("wibox")
local b = require("beautiful")
local gears = require("gears")
local TagList = require("widget.tag-list")
local TaskList = require("widget.task-list")




-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
    local lb = awful.widget.layoutbox(s)
    lb:buttons(
        gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
        )
    )
    return wibox.widget {
        widget = wibox.container.margin,
        margins = 4,
        lb
    }
end

local TopPanel = function(s)
    -- Create the wibox
    local panel = awful.wibar({ position = "top", screen = s, height = b.top_panel_height, bg = b.top_panel_bg })
    local tray = wibox.widget{
        wibox.widget.systray(),
        top = dpi(4),
        bottom = dpi(4),
        widget = wibox.container.margin
    }
    

    -- Add widgets to the wibox
    panel:setup {
        expand = "none",
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            TagList(s),
            TaskList(s),
        },
        require("widget.clock"),
        -- {
        --     layout = wibox.layout.flex.horizontal,
        --     max_widget_size = dpi(750) ,
        --     nil
        -- }, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(15),
            tray,
            require("widget.audio"),
            require("widget.ram-meter"),
            require("widget.cpu-meter"),
            awful.widget.keyboardlayout(),
            LayoutBox(s)
        }
    }
    return panel
end

return TopPanel