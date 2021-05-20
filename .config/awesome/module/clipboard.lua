local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local base = wibox.widget.base
local screen = _G.mouse.screen
local beautiful = require("beautiful")

local function getClipboard()
  local clipboard = io.popen("clipcatctl list"):lines()
  local clipboardItems = {}
  for line in clipboard do
    local id, data = line:match("(%w+):%s(.+)")
    table.insert(clipboardItems, {id = id, data = data})
  end
  return clipboardItems
end

local clipboardItem = function (clip)
  local widget = wibox.widget {
    widget = require("widget.clickable-container"),
    shape = function (cr,w,h)
      gears.shape.rounded_rect(cr,w,h,3)
    end,
    bg = "#1F2123",
    bg_focus = "#2B2E31",
    border_width = 1,
    border_color = "#3d3d3d",
    {
      widget = wibox.container.margin,
      margins = dpi(7),
      {
        widget = wibox.widget.textbox,
        text = clip.data
      }
    }
  }
  widget:connect_signal("button::press",function (_,_,_,btn)
    if btn ~= 1 then return end
    awful.spawn.easy_async_with_shell("clipcatctl promote "..clip.id)
    _G.awesome.emit_signal("module::clipboard")
  end)
  return widget
end

local clipboardItems = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(8),
}

local clipboardScroll = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  speed = dpi(15),
  spacing = dpi(2),
  {
    -- Scrollable container
    widget = wibox.container.margin,
    margins = dpi(7),
    {
      widget = wibox.container.background,
      clipboardItems
    }
  },
  {
    -- Scrollbar
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
    bg = "#8c8c8c",
    forced_width = dpi(5),
  }
}

function clipboardScroll:checkOnScrollbarClick(lx,ly)
  local w,h = self._private.width, self._private.height
  local containerHeight = self._private.widgets[1]._private.height
  local marginRight = self._private.widgets[1]._private.right

  if lx <= w - marginRight then return end
  self:setOffset(-ly / h * containerHeight)
  self:emit_signal("widget::layout_changed")
end

function clipboardScroll:setOffset(offset)
  self._private.offset = offset
end

function clipboardScroll:updateScrollPos(dir)
  self:setOffset(self._private.offset + (dir == "down" and - self.speed or self.speed))
  self:emit_signal("widget::layout_changed")
end

function clipboardScroll:layout(context, width, height)
  local container, scrollbar = table.unpack(self._private.widgets)
  local scrollbarWidth = scrollbar._private.forced_width
  local spacing = self._private.spacing
  local w, h = base.fit_widget(self, context, container, width - spacing, 2 ^ 1024)

  self._private.width = width
  self._private.height = height
  container._private.width = w
  container._private.height = h

  local offset = self._private.offset or 0

  if offset >= 0 then
    offset = 0
    self:setOffset(offset)
  end
  if math.abs(offset) >= h - height then
    offset = height - h
    self:setOffset(offset)
  end
  return {
    base.place_widget_at(container, 0, offset, w, h),
    base.place_widget_at(scrollbar,
      width - scrollbarWidth,
      -offset / h * height,
      scrollbarWidth,
      height / h * height
    )
  }
end

clipboardScroll:connect_signal("button::press",function (_,lx,ly,btn)
  if btn == 1 then
    clipboardScroll:checkOnScrollbarClick(lx,ly)
  end
  if btn < 4 then return end
  if btn == 4 then
    clipboardScroll:updateScrollPos("up")
  end
  if btn == 5 then
    clipboardScroll:updateScrollPos("down")
  end
end)

_G.screen.connect_signal("request::desktop_decoration", function (s)
  s.clipboard = wibox {
    screen = s,
    x = s.geometry.width / 2,
    y = s.geometry.height / 2,
    width = dpi(300),
    height = dpi(400),
    shape = function (cr,w,h)
      gears.shape.rounded_rect(cr,w,h, dpi(5))
    end,
    visible = false,
    ontop = true,
    bgimage = require("beautiful").noise()
  }
  s.clipboard:setup {
    widget = clipboardScroll
  }
end)

local function placeClipboard()
  local x, y = _G.mouse.coords().x, _G.mouse.coords().y
  local screenW, screenH = screen.geometry.width, screen.geometry.height
  local wbx = screen.clipboard

  screen.clipboard.x = x
  screen.clipboard.y = y

  if x + wbx.width > screenW then
    screen.clipboard.x = screenW - wbx.width - beautiful.top_panel_height
  end
  if y + wbx.height > screenH then
    screen.clipboard.y = screenH - wbx.height - beautiful.top_panel_height
  end
end

_G.awesome.connect_signal("module::clipboard",function ()
  screen.clipboard.visible = not screen.clipboard.visible
  placeClipboard()
  clipboardScroll._private.offset = 0
  clipboardItems:reset()
  for _,clip in ipairs(getClipboard()) do
    clipboardItems:add(clipboardItem(clip))
  end
end)