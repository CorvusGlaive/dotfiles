local wibox = require("wibox")
local naughty = require('naughty')
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local cmd = "~/.config/polybar/scripts/pulseaudio-control.bash"
local cmd_listen = [[bash -c ']]..cmd..[[ --listen' ]]

local pulse_control = wibox.widget.textbox()
pulse_control.font = "SymbolsNerdFont 10"

pulse_control:buttons(
    gears.table.join(
        awful.button({ }, 1 , function (c)
            -- if isMuted then
            awful.spawn.easy_async_with_shell(cmd .. " --togmute", function() end)
            -- naughty.notify {text = "Clicked LEFT"}
        end),
        awful.button({ }, 2 , function (c)
            awful.spawn.easy_async_with_shell(cmd .. " --change", function() end)
            -- naughty.notify {text = "Clicked MIDDLE"}
        end),
        awful.button({ }, 3 , function (c)
            -- awful.spawn.easy_async_with_shell(cmd .. " --mute", function() end)
            -- naughty.notify {text = "Clicked RIGHT"}
        end),
        awful.button({ }, 4 , function (c)
            awful.spawn.easy_async_with_shell(cmd .. " --up", function() end)
            -- naughty.notify {text = "Clicked WHEELUP"}
        end),
        awful.button({ }, 5 , function (c)
            awful.spawn.easy_async_with_shell(cmd .. " --down", function() end)
            -- naughty.notify {text = "Clicked WHEELDOWN"}
        end)
    )
)

awful.spawn.with_line_callback(cmd_listen,{
    stdout = function(s)
        -- local vol, devId = s:match('%D*%s(%d+)%s*%D*%s(%d+)')
        -- local volIcon,vol,devIcon, devId = s:match('(%D*)%s(%d+)%s*(%D*)%s(%d+)')
        -- devIcon = devIcon:sub(5,7)
        if #s > 15 then 
            local sub = s:match('}(.-)%%{') 
            pulse_control.markup = '<span foreground="#6b6b6b">' .. sub .. '</span>'
        else
            pulse_control.text = s
        end
    end
})

return pulse_control