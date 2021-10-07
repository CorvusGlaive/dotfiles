local fs = require("gears.filesystem")
return {
    default = {
        terminal = "kitty -c="..fs.get_configuration_dir().."configuration/kitty.conf",
        editor = os.getenv("EDITOR") or "nano",
        rofi = "rofi -show drun"
    },
    run_on_start_up = {
        "picom -b --experimental-backends",
        "xrdb -load ~/.Xresources",
        "clipcatd",
        "lxsession"
    }
}
