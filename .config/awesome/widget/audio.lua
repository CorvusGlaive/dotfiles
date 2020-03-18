local wibox = require("wibox")
local naughty = require('naughty')
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local cmd = require("scripts").audio

local pulse_control = wibox.widget.textbox()
-- pulse_control.font = "SymbolsNerdFont 10"
local sink_icons = {
    [1] = " ",
    [2] = " ",
    [3] = "蓼 ",
}
local vol_icons = {
    [1] =  " ", -- use first for volume-off state
    [2] =  " ",
    [3] =  "墳 ",
    [4] =  " "
}
local curDevice_icon = ' ' --Defualt sink icon if there is no matched devices


local function getCurDeviceIcon(name)
    if name == "Razer" then return sink_icons[2]
    elseif name == "Built" then return sink_icons[3]
    elseif name == "GF" then return sink_icons[1] end
    return curDevice_icon
end

local function getCurVolumeIcon(vol)
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
            -- if isMuted then
            awful.spawn.easy_async_with_shell(cmd.togmute, function() end)
            -- naughty.notify {text = "Clicked LEFT"}
        end),
        awful.button({ }, 2 , function (c)
            awful.spawn.easy_async_with_shell(cmd.change, function() end)
            -- naughty.notify {text = "Clicked MIDDLE"}
        end),
        awful.button({ }, 3 , function (c)
            -- awful.spawn.easy_async_with_shell(cmd .. " --mute", function() end)
            -- naughty.notify {text = "Clicked RIGHT"}
        end),
        awful.button({ }, 4 , function (c)
            awful.spawn.easy_async_with_shell(cmd.up, function() end)
            -- naughty.notify {text = "Clicked WHEELUP"}
        end),
        awful.button({ }, 5 , function (c)
            awful.spawn.easy_async_with_shell(cmd.down, function() end)
            -- naughty.notify {text = "Clicked WHEELDOWN"}
        end)
    )
)

_G.awesome.connect_signal("daemon::audio", function (dev)
    local volIcon = getCurVolumeIcon(dev.vol)
    local devIcon = getCurDeviceIcon(dev.name)
    if not dev.isMuted then
        pulse_control.markup = volIcon .. dev.vol .. "%" .. 
        "<span font='SymbolsNerdFont 11'>  " .. devIcon .. "</span>"
    else pulse_control.text = "MUTED" end
end)


return pulse_control