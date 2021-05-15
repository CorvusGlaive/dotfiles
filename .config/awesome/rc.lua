-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local xresources = require("beautiful.xresources")
-- Make dpi function global
dpi = xresources.apply_dpi
------------------------------------------------------------------------------
-- Themes define colours, icons, font and wallpapers.
beautiful.init(require("themes.theme"))
beautiful.maximized_hide_border = true


--Layout
require("layout")

--Modulus
require("module.notifications")
require("module.auto-start")
require("module.app-overview")
-- require("module.decorate-client")
require("module.wallpaper")
require("module.exit-screen")
require("module.volume-osd")

--Configurations
require("configuration.client")
require("configuration.tags")

--Daemons
require("module.audio-daemon")
-- Set keys
_G.root.keys(require("configuration.keys.global"))

-------------------------------------------------------------------------------
-- {{{ Variable definitions


-- Menubar configuration
menubar.utils.terminal = require("configuration.apps").default.terminal -- Set the terminal for applications that require it
-- }}}


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end)



-- {{{ Signals
-- Signal function to execute when a new client appears.
_G.client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if not _G.awesome.startup then
        awful.client.setslave(c)
    end

    if _G.awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)



-- Enable sloppy focus, so that focus follows mouse.
-- _G.client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

_G.client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
_G.client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}