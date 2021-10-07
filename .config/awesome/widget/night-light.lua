local wibox = require("wibox")
local awful = require("awful")


local state = false
local state_icon = {
  on = require("themes.icons").nightLight_on,
  off = require("themes.icons").nightLight_off,
}
local nightLight = wibox.widget {
  clickable = true,
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(6),
  {
    id = "icon",
    widget = wibox.widget.imagebox(state_icon.off)
  }
}

nightLight:connect_signal("button::press", function (self,lx,ly,btn,_,res)
  if btn ~= 1 then return end
 state = not state
 if state then
  awful.spawn.with_shell("redshift -O 4900",function () end)
 else
  awful.spawn.with_shell("redshift -x")
 end
 nightLight.icon.image = state and state_icon.on or state_icon.off
end)



return nightLight
