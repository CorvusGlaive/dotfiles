local awful = require("awful")
local gears = require("gears")

local listen_script = require('scripts').audio.listen
-- local curDevice_script = require('scripts').audio.curDevice

local kill_listeners = "ps x | grep 'pactl subscribe' | grep -v grep | awk '{print $1}' | xargs kill"


local function emit_audio_info(vol,sink,isMuted, devName)
    -- print(devName .. ": " .. curDevice_icon)
    local curDevice_stats = {
        vol = vol,
        sink = sink,
        isMuted = isMuted,
        name = devName
    }
    _G.awesome.emit_signal("daemon::audio",curDevice_stats)
end

awful.spawn.easy_async_with_shell(kill_listeners, function ()
    awful.spawn.with_line_callback(listen_script,{
        stdout = function(events)
            local vol, sink, isMuted, devName = events:match('(%d+)|(%d)|(%a+)|"(%a+)')
            if isMuted == "yes" then isMuted = true
            else isMuted = false end
            emit_audio_info(tonumber(vol),tonumber(sink),isMuted, devName)
        end
    })
end)