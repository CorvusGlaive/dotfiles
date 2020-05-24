local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local btl = require("beautiful")

-- Add a titlebar if titlebars_enabled is set to true in the rules.
_G.client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }
    local args = {
        size = require("beautiful").titlebar_size
    }
    if c.class == "kitty" then
        args = {
            bg_normal = "#101010" .. btl.opacityHex(0.5),
            bg_focus = "#101010" .. btl.opacityHex(0.5),
            bgimage = btl.noise()
        }
    end
    if c.class == "Alacritty" then
        args = {
            bg_normal = "#101010" .. btl.opacityHex(0.6),
            bg_focus = "#101010" .. btl.opacityHex(0.6),
        }
    end
    awful.titlebar(c,args) : setup {
       widget = wibox.container.margin,
       margins = {
           left = dpi(10),
           right = dpi(10)
       },
       {
        { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal,
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
        },
        { -- Right
            widget = wibox.container.margin,
            margins = {
                top = dpi(3),
                bottom = dpi(3)
            },
            {    -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton    (c),
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal()
            }
        },
        layout = wibox.layout.align.horizontal
       }
    }
end)