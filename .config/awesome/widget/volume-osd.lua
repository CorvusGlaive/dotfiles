local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

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
        bg = "#00000000",
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
        timeout = 5,
        autostart = true,
        callback  = function()
        volume_widget.visible = false
        end
    }
    local volume_subscribe = [[
        bash -c '
        pactl subscribe 2> /dev/null | grep --line-buffered "sink"
    ']]
    local volume_status = 'pulseaudio-ctl full-status'
    local showVolumeOSD = false

    function toggleVolOSD()
        showVolumeOSD = true
    end

    -- awful.spawn.easy_async_with_shell("ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
        -- Run emit_volume_info() with each line printed
        awful.spawn.with_line_callback(volume_subscribe, {
            stdout = function()
                awful.spawn.easy_async(volume_status,function(s)
                    if not showVolumeOSD then return end
                    local vol, isMuted = s:match('(%d+)%s(%a+)%s')
                    volume_value.text = vol .. "%"
                    volume_bar.value = tonumber(vol)
                    volume_widget.visible = true
                    if isMuted == "yes" then volume_bar.color = "#8c8c8c"
                    else volume_bar.color = "#94cc9a" end
                    hideOSD:again()
                    showVolumeOSD = false
                end)
            end
        })
    -- end)

    return volume_widget
end

awful.screen.connect_for_each_screen(function(s)
    s.volumeOSD = volumeOverlay(s)
end)