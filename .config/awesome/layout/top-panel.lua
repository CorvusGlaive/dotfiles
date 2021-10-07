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
        margins = dpi(4),
        lb
    }
end

local exit_button = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(4),
    {
        widget = wibox.widget.imagebox,
        image = require("themes.icons").logout,
        resize = true,
    }
}
local showDesktop_button = wibox.widget {
    widget = require('widget.clickable-container'),
    {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.background,
            bg = '#ffffff'..b.opacityHex(0.2),
            forced_width = dpi(1),
            wibox.widget.base.make_widget()
        },
        {
            widget = wibox.container.background,
            forced_width = dpi(7),
            wibox.widget.base.make_widget()
        }
    }
}
showDesktop_button:connect_signal('mouse::enter',function()
    for i,c in pairs(_G.screen[_G.mouse.screen].selected_tag:clients()) do
        c.opacity = 0
    end
end)
showDesktop_button:connect_signal('mouse::leave',function()
    for i,c in pairs(_G.screen[_G.mouse.screen].selected_tag:clients()) do
        c.opacity = 1
    end
end)
showDesktop_button:connect_signal('button::press',function()
    for i,c in pairs(_G.screen[_G.mouse.screen].selected_tag:clients()) do
        c.minimized = not c.minimized
    end
end)

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

local function addClickableMargins(widget,margins,isClickable)
    isClickable = (isClickable == nil) and true or isClickable
    margins = (margins == nil) and 7 or margins
    return wibox.widget {
        widget = isClickable and require("widget.clickable-container") or wibox.container.background,
        {
            widget = wibox.container.margin,
            margins = {
                left = dpi(margins),
                right = dpi(margins)
            },
            widget
        }
    }
end

local TopPanel = function(s)
    -- Create the wibox
    local panel = awful.wibar({ position = "bottom", screen = s, height = b.top_panel_height, bg = b.top_panel_bg,
    bgimage = b.noise() })
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
            spacing = dpi(1),
            tray,
            addClickableMargins(require("widget.night-light")),
            addClickableMargins(require("widget.audio")),
            addClickableMargins(require("widget.ram-meter"),nil,false),
            addClickableMargins(require("widget.cpu-meter"),nil,false),
            addClickableMargins(awful.widget.keyboardlayout(),4),
            addClickableMargins(LayoutBox(s),4),
            addClickableMargins(require("widget.clock"),10),
            addClickableMargins(exit_button,4),
            showDesktop_button
        }
    }
    return panel
end

return TopPanel
