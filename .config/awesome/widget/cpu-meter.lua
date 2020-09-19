local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")

local cpu_meter_text = wibox.widget.textbox()
local total_prev = 0
local idle_prev = 0

watch(
  [[bash -c "cat /proc/stat | grep '^cpu '"]],
  1,
  function(_, stdout)
    local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
      stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    cpu_meter_text:set_text(math.floor( diff_usage ) .. "%")

    total_prev = total
    idle_prev = idle
    collectgarbage('collect')
  end
)
local cpu_meter = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.margin,
    margins = {
      top = dpi(6),
      bottom = dpi(6),
      right = dpi(6),
    },
    wibox.widget.imagebox(require('themes.icons').cpu)
  },
  cpu_meter_text
}
return cpu_meter