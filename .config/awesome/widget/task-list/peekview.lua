local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local screen = _G.screen[_G.mouse.screen]
local focusWithin = false
local timerDelay = 0.6

local peekview_showTimer = gears.timer {timeout = timerDelay, single_shot = true}
local peekview_hideTimer = gears.timer {timeout = timerDelay, single_shot = true}

local peekview_widget = wibox.widget.base.make_widget()

local peekview_popup = awful.popup {
  widget = peekview_widget,
  bgimage = beautiful.noise(0.2),
  border_color = '#6b6b6b',
  border_width = 1,
  ontop        = true,
  preferred_positions = 'top',
  preferred_anchors   = 'middle',
  visible      = false,
  shape = function(cr,w,h) return gears.shape.rounded_rect(cr,w,h,5) end
}

local peekview_layout = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = dpi(1),
  spacing_widget =  {
    forced_width = dpi(1),
    color = "#b2b2b2",
    orientation = 'vertical',
    widget = wibox.widget.separator,
  }
}


local function createPeekviewWidget(c, index,idxs)
  local cw,ch = gears.surface.get_size(gears.surface(c.content))
  local h = dpi(200)   -- widget height
  local ratio = math.min(screen.geometry.width / (screen.geometry.height - beautiful.top_panel_height),
                        cw / ch)
  local w = math.floor(h * ratio)
  local scale = (cw > ch) and (w / cw) or (h / ch)

  peekview_widget = wibox.widget.base.make_widget()

  function peekview_widget:fit(self,width,height)
    return w,math.floor(ch * scale)
  end

  function peekview_widget:draw(peekview_widget,cr,width,height)
    local tmp = gears.surface(c.content)
    cr:translate(0, 0)
    cr:scale(scale,scale)
    cr:set_source_surface(tmp, 0, 0)
    cr:paint()
    tmp:finish()
  end
  peekview_widget:connect_signal('button::press',function(p_widget,lx,ly,button)
    if button == 2 then
      for i,v in pairs(idxs) do
        if v == index then
          peekview_layout:remove(i)
        end
      end
      c:kill()
      peekview_popup.x  = peekview_popup.x + w / 2
      if peekview_hideTimer.started then peekview_hideTimer:stop() end
      return
    end
    c:activate()
    _G.mouse.coords {
    x = c.x + c.width / 2,
    y = c.y + c.height / 2
    }
    peekview_popup.visible = false
  end)
  return require('widget.clickable-container')(
    wibox.widget {
      layout = wibox.layout.fixed.vertical,
      {
        widget = wibox.container.constraint,
        strategy = 'max',
        width = dpi(w - 5),
        height = dpi(26),
        {
          widget = wibox.container.background,
          bg = '#0000004d',
          {
            widget = wibox.container.margin,
            margins = dpi(5),
            {
              fill_space = true,
              layout = wibox.layout.fixed.horizontal,
              spacing = 5,
              {
                widget = wibox.widget.imagebox,
                image = c.icon and c.icon or require('themes.icons').app_icon,
                forced_height = dpi(15),
                forced_width = dpi(15),
              },
              {
                widget = wibox.widget.textbox,
                text = c.name
                  -- font = 'Inter Semibold 12'
              }
            }
          }
        }
      },
      {
        widget = wibox.container.margin,
        margins = dpi(5),
        {
          widget = wibox.container.background,
          forced_height = h,
          forced_width = w,
          {
            widget = wibox.container.place,
            {
              widget = wibox.container.background,
              shape = function(cr,w,h) return gears.shape.rounded_rect(cr,w,h,5) end,
              peekview_widget,
            }
          },
        }
      },
    },
    "#ffffff"..beautiful.opacityHex(0.2)
  )
end

local function createPeekviewPopup(widget,client)

  widget:connect_signal("mouse::enter",function ()
    if client.minimized then return end
    local idxs = {}
    for i,c in pairs(screen:get_clients(false)) do
      if c.class == client.class then
        table.insert(idxs,i)
      end
    end

    peekview_layout:reset()
    for i,c in pairs(screen:get_clients(false)) do
      if client.class == c.class then
        peekview_layout:add(createPeekviewWidget(c,i,idxs))
      end
    end
    peekview_popup.widget = wibox.widget {
      widget = wibox.container.background,
      peekview_layout
    }
    peekview_showTimer:again()
  end)

  widget:connect_signal("mouse::leave",function (w)
    if peekview_showTimer.started and not focusWithin then peekview_showTimer:stop() return end
    if peekview_popup.visible and focusWithin then peekview_showTimer.timeout = 0 return end
  end)

  widget:connect_signal("button::press",function (w)
    local isTimerStarted = peekview_showTimer.started
    local toggleClientMin = function () client:activate { context = "tasklist", action = "toggle_minimization" } end
    if isTimerStarted and w.hasGroup then
      peekview_showTimer:stop()
      peekview_popup:move_next_to(screen.top_panel)
      local curWidgetGeo = _G.mouse.current_widget_geometry
      peekview_popup.x  = curWidgetGeo.x - peekview_popup.width / 2 + curWidgetGeo.width / 2
      return
    end
    if isTimerStarted and not w.hasGroup then toggleClientMin() peekview_showTimer:stop() return end
    if not isTimerStarted and not w.hasGroup then toggleClientMin() peekview_popup.visible = false return end
  end)
end

peekview_popup:connect_signal('mouse::enter',function()
  if peekview_hideTimer.started then peekview_hideTimer:stop() end
end)
peekview_popup:connect_signal('mouse::leave',function()
  if peekview_popup.visible then peekview_hideTimer:again() end
end)

peekview_showTimer:connect_signal("timeout",function()
  peekview_popup:move_next_to(screen.top_panel)
  local curWidgetGeo = _G.mouse.current_widget_geometry
  peekview_popup.x  = curWidgetGeo.x - peekview_popup.width / 2 + curWidgetGeo.width / 2
end)
peekview_hideTimer:connect_signal("timeout",function() peekview_popup.visible = false end)

_G.awesome.connect_signal('widget::tasklist_focus',function (isFocused)
  focusWithin = isFocused
  if not isFocused then
    peekview_showTimer.timeout = timerDelay
    peekview_hideTimer:again()
  end
end)
return createPeekviewPopup