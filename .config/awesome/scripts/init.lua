local fs = require('gears.filesystem')


local function getScriptPath(name)
    local path = fs.get_configuration_dir() .. "scripts/" .. name
    return function (args)
        return args and path .. ' ' .. args or path
    end
end

local pulse_control = getScriptPath("pulseaudio-control.bash")

return {
    audio = {
        src = pulse_control(),
        listen = pulse_control('--listen'),
        up = pulse_control("--up"),
        down = pulse_control("--down"),
        togmute = pulse_control("--togmute"),
        change = pulse_control("--change"),
        devices = pulse_control("--devices"),
        curDevice = pulse_control("--current-device")
    }
}