local awful = require("awful")
local gears = require("gears")


local delayInMins = 15

local mins = (delayInMins - tonumber(os.date("%M")) % delayInMins) * 60
local firstRunDelay = mins - tonumber(os.date("%S"))

local lines = io.popen('find '..os.getenv("HOME")..'/Pictures/ -type f'):lines()
local files = {}
for file in lines do
    local pos = math.random(#files + 1)
    table.insert(files, pos, file)
end
local currentFile = 1
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
		local surface = gears.surface(files[currentFile])
        require("beautiful").wallpaper = surface
        gears.wallpaper.maximized(surface)
        currentFile = currentFile >= #files and 1 or currentFile + 1
    end
}


