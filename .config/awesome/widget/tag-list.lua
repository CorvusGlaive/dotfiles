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
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        -- style   = {
        --     shape = gears.shape.rounded_rect
        -- },
        widget_template = {
            id = 'background_role',
            widget = wibox.container.background,
            {
                layout = wibox.layout.stack,
                {
                    margins = 4,
                    widget = wibox.container.margin,
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox
                    }
                },
                {
                    widget = wibox.container.margin,
                    top = beautiful.taglist_underline_height,
                    {
                        id = "underline_role",
                        widget = wibox.container.background,
                        bg = "#fccf05",
                        {widget = wibox.container.margin},
                    },
                },
            },
            create_callback = function (self,tag,idx,obj)
              local underline = self:get_children_by_id('underline_role')[1]
              if tag.selected then underline.bg = beautiful.taglist_underline_bg
              else underline.bg = "#00000000" end
            end,
            update_callback = function (self,tag,idx,obj)
              local underline = self:get_children_by_id('underline_role')[1]
              if tag.selected then underline.bg = beautiful.taglist_underline_bg
              else underline.bg = "#00000000" end
            end
        },

    }
end

return TagList