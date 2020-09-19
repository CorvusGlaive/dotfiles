local awful = require("awful")
local modkey = require("configuration.keys.mod").modKey
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if _G.client.focus then
            _G.client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if _G.client.focus then
            _G.client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Create a taglist widget
local TagList = function(s)
    return awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
        style   = {
            shape = function (cr,w,h) return gears.shape.rounded_rect(cr,w,h,2) end
        },
        widget_template = {
            widget = require("widget.clickable-container"),
            {
                widget = wibox.container.margin,
                margins = dpi(3),
                {
                    id = 'background_role',
                    widget = wibox.container.background,
                    {
                        margins = {
                            left = dpi(6),
                            right = dpi(6),
                            top = dpi(2),
                            bottom = dpi(2),
                        },
                        widget = wibox.container.margin,
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox
                        }
                    }
                }
            }
        },

    }
end

return TagList