local awful = require('awful')
local gears = require('gears')

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
}

awful.screen.connect_for_each_screen(
    function (s)
        for i=1,9 do
            awful.tag.add(
                i,
                {
                    layout = awful.layout.suit.floating,
                    gap_single_client = false,
                    gap = 4,
                    screen = s,
                    selected = i == 1
                }
            )
        end
    end
)