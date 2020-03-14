local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ram_meter = wibox.widget.textbox()

local ram_script = [[
  sh -c "
  free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
  "]]

watch(ram_script, 5, function(widget, stdout)
  local available = stdout:match('(.*)@@')
  local total = stdout:match('@@(.*)@')
  local used = tonumber(total) - tonumber(available)
  local used_in_percentage = math.floor(used / total * 100)
  ram_meter.markup = '<span font="FontAwesome5Free 10"> </span>' .. used_in_percentage .. "%"
  -- awesome.emit_signal("evil::ram", used, tonumber(total))
end)

return ram_meter