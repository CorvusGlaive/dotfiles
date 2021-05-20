local wibox = require("wibox")
local naughty = require('naughty')
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local cmd = require("scripts").audio

local pulse_control_text = wibox.widget.textbox()
local pulse_control_vol_icon = wibox.widget.imagebox()
local pulse_control_dev_icon = wibox.widget.imagebox()
local pulse_control = wibox.widget {

        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(2),
        {
            widget = wibox.container.margin,
            margins = {
                top = dpi(6),
                bottom = dpi(6),
                right = dpi(6),
            },
            pulse_control_vol_icon
        },
        pulse_control_text,
        {
            widget = wibox.container.margin,
            margins = {
                left = dpi(6),
                top = dpi(6),
                bottom = dpi(6),
            },
            pulse_control_dev_icon
        }

}
-- pulse_control.font = "SymbolsNerdFont 10"
local sink_icons = {
    [1] = require('themes.icons').hdmi,
    [2] = require('themes.icons').headphones,
    [3] = require('themes.icons').speaker,
}
local vol_icons = {
    [1] =  require('themes.icons').close, -- use first for volume-off state
    [2] =  require('themes.icons').volume_down,
    [3] =  require('themes.icons').volume,
    [4] =  require('themes.icons').volume_up
}
local curDevice_icon = require('themes.icons').plus --Default sink icon if there are no matched devices


local function getCurDeviceIcon(name)
    if name == "Razer" or name == "Kraken" then return sink_icons[2]
    elseif name == "Built" then return sink_icons[3]
    elseif name == "GF" then return sink_icons[1] end
    return curDevice_icon
end

local function getCurVolumeIcon(vol)
    vol = (vol == nil) and 0 or vol
    local vol_split = math.floor(100 / #vol_icons - 1)
    local icon = ''
    if vol == 0 then return vol_icons[1] end
    for i,v in ipairs(vol_icons) do
        if i ~= 1 and i * vol_split >= vol then
            icon = v;
            break
        end
    end
    return icon
end

pulse_control:buttons(
    gears.table.join(
        awful.button({ }, 1 , function (c)
            awful.spawn.easy_async_with_shell(cmd.togmute, function() end)
            _G.awesome.emit_signal("module::volume-osd")
        end),
        awful.button({ }, 2 , function (c)
            awful.spawn.easy_async_with_shell(cmd.change, function() end)
        end),
        awful.button({ }, 3 , function (c)
            -- awful.spawn.easy_async_with_shell(cmd .. " --mute", function() end)
        end),
        awful.button({ }, 4 , function (c)
            awful.spawn.easy_async_with_shell(cmd.up, function() end)
            _G.awesome.emit_signal("module::volume-osd")
        end),
        awful.button({ }, 5 , function (c)
            awful.spawn.easy_async_with_shell(cmd.down, function() end)
            _G.awesome.emit_signal("module::volume-osd")
        end)
    )
)

_G.awesome.connect_signal("daemon::audio", function (dev)
    local volIcon = getCurVolumeIcon(dev.vol)
    local devIcon = getCurDeviceIcon(dev.name)
    dev.vol = (dev.vol == nil) and 0 or dev.vol
    if not dev.isMuted then
        pulse_control_vol_icon:set_image(volIcon)
        pulse_control_text:set_text(dev.vol.."%")
        pulse_control_dev_icon:set_image(devIcon)
    else
        pulse_control_vol_icon:set_image(require('themes.icons').volume_mute)
    end
end)


return pulse_control