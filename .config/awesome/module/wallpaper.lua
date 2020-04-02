local awful = require("awful")
local gears = require("gears")


local delayInMins = 15

local mins = (delayInMins - tonumber(os.date("%M")) % delayInMins) * 60
local firstRunDelay = mins - tonumber(os.date("%S"))

return gears.timer {
    autostart = true,
    timeout = firstRunDelay,
    call_now = true,
    callback = function(self)
        if self then
            self:stop()
            self.timeout = delayInMins * 60
            self:again()
        end
        awful.spawn.easy_async_with_shell('feh --bg-fill -z ~/Pictures', function ()end)
    end
}


