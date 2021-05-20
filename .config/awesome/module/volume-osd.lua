local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local volumeOverlay = function (s)
    local w = dpi(314)
    local h = dpi(20)

    local volume_wibox = wibox {
        visible = false,
        screen = s,
        ontop = true,
        type = "dock",
        width = w,
        height = h,
        bg = beautiful.bg_normal,
        shape = function (cr,w,h)
            gears.shape.rounded_rect(cr,w,h,dpi(5))
        end,
        x = s.geometry.width / dpi(2) - w / dpi(2),
        y = s.geometry.height - 100,
    }

    local volume_bar = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(2),
        color = beautiful.bg_focus,
        bg = "#3d3d3d"
    }
    for i = 1, 50, 1 do
        volume_bar:add(wibox.widget {
            widget = wibox.container.background,
            forced_height = dpi(6),
            forced_width = dpi(4),
            shape = function (cr,w,h)
                gears.shape.rounded_rect(cr,w,h,dpi(2))
            end,
        })
    end
    function volume_bar:set_value(value)
        local index = value / 100 * 50
        self._private.value = index
        for i,v in ipairs(self._private.widgets) do
            if i <= index then v.bg = self.color or "#8cccaf"
            else v.bg = self.bg
            end
        end
    end
    function volume_bar:set_color(color)
        local wdgs = self._private.widgets
        for i = 1, self._private.value, 1 do
            wdgs[i].bg = color
        end
    end

    local volume_value = wibox.widget {
        text = "50%",
        font = require('beautiful').title_font,
        widget = wibox.widget.textbox
    }


    volume_wibox:setup {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.place,
            valign = "center",
            {
                widget = wibox.container.margin,
                left = dpi(4),
                right = dpi(4),
                volume_bar
            }
        },
        {
            widget = wibox.container.place,
            halign = "center",
            {
                widget = wibox.container.background,
                fg = "#FFF",
                volume_value,
            }
        }
    }

    local showVolumeOSD = false

    local hideOSD = gears.timer {
        timeout = 3,
        autostart = true,
        single_shot = true,
        callback  = function()
            volume_wibox.visible = false
            showVolumeOSD = false
        end
    }


    _G.awesome.connect_signal("module::volume-osd", function ()
        showVolumeOSD = true
    end)

    _G.awesome.connect_signal("daemon::audio",function(dev)
        if not showVolumeOSD then return end

        volume_value.text = tostring(dev.vol) .. "%"
        volume_bar:set_value(dev.vol)
        volume_wibox.visible = true

        if dev.isMuted then volume_bar:set_color("#8c8c8c") end

        hideOSD:again()
    end)

    return volume_wibox
end

awful.screen.connect_for_each_screen(function(s)
    s.volumeOSD = volumeOverlay(s)
end)