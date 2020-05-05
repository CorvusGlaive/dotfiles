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
        widget = require("widget.clickable-container"),
        {
            widget = wibox.container.margin,
            margins = dpi(4),
            lb
        }
    }
end

local exit_button = wibox.widget {
    widget = require("widget.clickable-container"),
    {
        widget = wibox.container.margin,
        margins = dpi(4),
        {
            widget = wibox.widget.imagebox,
            image = require("themes.icons").logout,
            resize = true,
        }
    },
}

exit_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                _G.exit_screen_show()
            end
        )
    )
)

local function addClickableMargins(w,m)
    m = (m == nil) and 7 or m
    return wibox.widget {
        widget = require("widget.clickable-container"),
        {
            widget = wibox.container.margin,
            margins = {
                left = dpi(m),
                right = dpi(m)
            },
            w
        }
    }
end

local TopPanel = function(s)
    -- Create the wibox
    local panel = awful.wibar({ position = "bottom", screen = s, height = b.top_panel_height, bg = b.top_panel_bg })
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
        {
            layout = wibox.layout.fixed.horizontal,
            require("widget.app-launcher"),
            TagList(s),
        },
        TaskList(s),
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(15),
            tray,
            addClickableMargins(require("widget.audio")),
            require("widget.ram-meter"),
            require("widget.cpu-meter"),
            addClickableMargins(awful.widget.keyboardlayout(),4),
            LayoutBox(s),
            addClickableMargins(require("widget.clock")),
            exit_button
        }
    }
    return panel
end

return TopPanel