local awful = require("awful")
local top_panel = require("layout.top-panel")

awful.screen.connect_for_each_screen(
    function(s)
        --Create Top Bar
        s.top_panel = top_panel(s)
    end
)