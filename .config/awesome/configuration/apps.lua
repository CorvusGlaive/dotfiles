local fs = require("gears.filesystem")
return {
    default = {
        terminal = "kitty -c="..fs.get_configuration_dir().."configuration/kitty.conf",
        editor = os.getenv("EDITOR") or "nano",
        rofi = "rofi -show drun"
    },
    run_on_start_up = {
        -- "compton --config " .. fs.get_configuration_dir() .. "/configuration/compton.conf",
        "picom -b --experimental-backends",
        "xrdb -load ~/.Xresources",
        "clipcatd"
        -- "nvidia-settings -a [gpu:0]/GPUPowerMizerMode=1 > /dev/null "
    }
}
