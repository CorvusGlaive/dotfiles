local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local ruled = require('ruled')
local wibox = require("wibox")

-- Naughty presets
naughty.config.padding = 8
naughty.config.spacing = 8

naughty.config.defaults.timeout = 5
-- naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.ontop = true
naughty.config.defaults.font = 'Inter 10'
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.shape = gears.shape.rounded_rect
naughty.config.defaults.border_width = 1
naughty.config.defaults.border_color = "#6b6b6b"
naughty.config.defaults.hover_timeout = nil

local markup  = require("naughty.widget._markup").set_markup
local gtable  = require("gears.table")
local textbox = require("wibox.widget.textbox")
local title = {}

--Took this code from awesome's lib to change notification title's font
function title:set_notification(notif)
  if self._private.notification == notif then return end

  if self._private.notification then
      self._private.notification:disconnect_signal("property::message",
          self._private.title_changed_callback)
      self._private.notification:disconnect_signal("property::fg",
          self._private.title_changed_callback)
  end

  markup(self, notif.title, notif.fg, notif.font)

  self._private.notification = notif
  self._private.title_changed_callback()

  notif:connect_signal("property::title", self._private.title_changed_callback)
  notif:connect_signal("property::fg"   , self._private.title_changed_callback)
  self:emit_signal("property::notification", notif)
end

local function new(args)
  args = args or {}
  local tb = textbox()
  tb:set_wrap("word")
  tb:set_font(beautiful.notification_font)

  gtable.crush(tb, title, true)

  function tb._private.title_changed_callback()
      markup(
          tb,
          tb._private.notification.title,
          tb._private.notification.fg,
          "Inter Semibold 11"
      )
  end

  if args.notification then
      tb:set_notification(args.notification)
  end

  return tb
end

title = setmetatable(title, {__call = function(_, ...) return new(...) end})

ruled.notification.connect_signal('request::rules', function()
	
	-- Critical notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'critical' },
		properties = { 
			font        		= 'Inter Bold 10',
			bg 					= '#ff0000', 
			fg 					= '#ffffff',
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 0,
      implicit_timeout	= 0,
		}
	}

	-- Normal notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'normal' },
		properties = {
			bg      			= beautiful.background, 
			fg 					= beautiful.fg_normal,
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 0,
			implicit_timeout 	= 0
		}
	}

	-- Low notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'low' },
		properties = { 
			bg     				= beautiful.background,
			fg 					= beautiful.fg_normal,
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 5,
			implicit_timeout	= 5
		}
	}
end)

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
      urgency = "critical",
      title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
      message = message,
      app_name = 'System Notification',
      icon = beautiful.awesome_icon
  }
end)

naughty.connect_signal("request::display", function(n)
  local action_list = wibox.widget {
    notification = n,
    base_layout = wibox.widget {
      layout = wibox.layout.flex.vertical,
      spacing = dpi(1),
      spacing_widget = wibox.widget {
        color = "#c1c1c1",
        orientation = 'horizontal',
        widget = wibox.widget.separator,
      },
    },
    widget = naughty.list.actions,
    style = { underline_normal = false, underline_selected = true },
    widget_template = {
      widget = wibox.container.background,
      forced_height = dpi(30),
      {
        widget = wibox.container.place,
        {
          widget = wibox.widget.textbox,
          id = 'text_role',
        },
      },
    },
  }
  naughty.layout.box {
    notification = n,
    screen = awful.screen.focused(),
    shape = gears.shape.rounded_rect,
    widget_template = {
      id = "background_role",
      widget = naughty.container.background,
      {
        layout = wibox.layout.fixed.vertical,
        {
          widget = wibox.container.background,
          bg = '#0000004d',
          {
            widget = wibox.container.place,
            halign = 'center',
            {
              widget = wibox.widget.textbox,
              text = n.app_name,
              font = 'Inter Semibold 10'
            }
          }
        },
        {

          widget = wibox.container.margin,
          margins = 10,
          {
            strategy = "max",
            width = beautiful.notification_max_width or dpi(400),
            widget = wibox.container.constraint,
            {
              strategy = "min",
              width = dpi(350),
              widget = wibox.container.constraint,
              {
                spacing = 0,
                layout = wibox.layout.fixed.horizontal,
                {
                  fill_space = true,
                  spacing    = 10,
                  layout     = wibox.layout.fixed.horizontal,
                  {
                    widget = wibox.container.place,
                    valign = 'center',
                    {
                      widget = naughty.widget.icon,
                      resize_strategy = 'scale'
                    }
                  },
                  {
                    spacing = 2,
                    layout  = wibox.layout.fixed.vertical,
                    title,
                    {
                      widget = wibox.container.constraint,
                      strategy = "exact",
                      width = dpi(280),
                      naughty.widget.message,
                    },
                  },
                },
                action_list,
              }
            }
          }
        },
      }
    }
  }
end)

function log_this(title,text,bgColor)
  title = title or "Title"
  text = text or "Text"
  local colors = {
    red = "#b52f3c",
    green = "#65c668",
    orange = "#fca541",
    purple = "#9f41fc"
  }
  return require('naughty').notification {
    title = title,
    message = tostring(text),
    bg = colors[bgColor],
    font = "RobotoMedium 14",
    timeout= 2
  }
end