local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local volumeOverlay = function (s)
    local w = dpi(300)
    local h = dpi(20)

    local volume_widget = wibox {
        visible = false,
        screen = s,
        ontop = true,
        type = "dock",
        width = w,
        height = h,
        bg = beautiful.transparent,
        shape = gears.shape.rounded_bar,
        x = s.geometry.width / dpi(2) - w / dpi(2),
        y = s.geometry.height - 100,
    }

    local volume_bar = wibox.widget {
        max_value     = 100,
        value         = 50,
        color         = "#8cccaf",
        background_color = "#22222266",
        widget        = wibox.widget.progressbar,
    }

    local volume_value = wibox.widget {
        text = "50%",
        font = require('beautiful').title_font,
        widget = wibox.widget.textbox
    }
    

    volume_widget:setup {
        layout = wibox.layout.stack,
        volume_bar,
        {
            volume_value,
            halign = "center",
            widget = wibox.container.place
        }
    }
    local hideOSD = gears.timer {
        timeout = 3,
        autostart = true,
        single_shot = true,
        callback  = function()
            volume_widget.visible = false
        end
    }

    local showVolumeOSD = false

    function toggleVolOSD()
        showVolumeOSD = true
    end

    _G.awesome.connect_signal("daemon::audio",function(dev)
        if not showVolumeOSD and not volume_widget.visible then return end

        volume_value.text = tostring(dev.vol) .. "%"
        volume_bar.value = dev.vol
        volume_widget.visible = true

        if dev.isMuted then volume_bar.color = "#8c8c8c"
        else volume_bar.color = beautiful.bg_focus or "#94cc9a" end

        hideOSD:again()
        showVolumeOSD = false
    end)

    return volume_widget
end

awful.screen.connect_for_each_screen(function(s)
    s.volumeOSD = volumeOverlay(s)
end)