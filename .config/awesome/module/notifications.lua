local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')

-- Naughty presets
naughty.config.padding = 8
naughty.config.spacing = 8

naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.ontop = true
naughty.config.defaults.font = 'Inter Medium 10'
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.shape = gears.shape.rounded_rect
naughty.config.defaults.border_width = 1
naughty.config.defaults.border_color = "#6b6b6b"
naughty.config.defaults.hover_timeout = nil

-- Error handling
if _G.awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = 'Oops, there were errors during startup!',
      text = _G.awesome.startup_errors
    }
  )
end

do
  local in_error = false
  _G.awesome.connect_signal(
    'debug::error',
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = 'Oops, an error happened!',
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end

function log_this(title,text,bgColor)
  title = title or "Title"
  -- text = text or "Text"
  local colors = {
    red = "#b52f3c",
    green = "#65c668",
    orange = "#fca541",
    purple = "#9f41fc"
  }
  return require('naughty').notify {
    title = title,
    text = tostring(text),
    bg = colors[bgColor],
    font = "RobotoMedium 14",
    timeout= 2
  }
end