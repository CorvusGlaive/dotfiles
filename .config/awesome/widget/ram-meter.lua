local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ram_meter_text = wibox.widget.textbox()

local ram_script = [[
  sh -c "
  free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
  "]]

watch(ram_script, 5, function(widget, stdout)
  local available = stdout:match('(.*)@@')
  local total = stdout:match('@@(.*)@')
  local used = tonumber(total) - tonumber(available)
  local used_in_percentage = math.floor(used / total * 100)
  ram_meter_text.text = used_in_percentage .. "%"
  -- awesome.emit_signal("evil::ram", used, tonumber(total))
end)

local ram_meter = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.margin,
    margins = {
      top = dpi(6),
      bottom = dpi(6),
      right = dpi(6),
    },
    wibox.widget.imagebox(require('themes.icons').memory)
  },
  {
    widget = wibox.container.constraint,
    strategy = "min",
    widht = require("beautiful").top_panel_height,
    ram_meter_text
  }
}

return ram_meter