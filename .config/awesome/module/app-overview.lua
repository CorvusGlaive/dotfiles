local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local screen = _G.mouse.screen
local clients = function () return screen:get_clients(false) end
local base = wibox.widget.base
local beautiful = require("beautiful")

local appOverview_layout = wibox.layout.manual()

_G.screen.connect_signal("request::desktop_decoration", function (s)
  s.appOverview = wibox {
    screen = s,
    width = s.geometry.width,
    height = s.geometry.height - beautiful.top_panel_height,
    x = 0,
    y = 0,
    ontop = true,
    visible = false,
    bg = "#222"
  }
  s.appOverview:setup {
    widget = wibox.container.margin,
    margins = dpi(50),
    {
      widget = wibox.container.background,
      shape = gears.shape.rounded_rect,
      border_width = dpi(1),
      border_color = beautiful.border_normal,
      bg = "#ffb300",
      bgimage = function (ctx, cr, width, height)
        local ratio = width / height
        local img = gears.surface(beautiful.wallpaper or gears.colors("#ffb300"))
        local imgW,imgH = gears.surface.get_size(img)
        local scale = imgW / imgH > ratio and height / imgH or width / imgW

        cr:scale(scale, scale)
        cr:translate(
          imgW/imgH > ratio and (width - imgW * scale) / 2 or 0,
          imgW/imgH > ratio and 0 or (height - imgH * scale) / 2
        )
        cr:set_source_surface(img)
        local pat = cr:get_source()
        pat:set_filter("FAST")
        cr:paint()
      end,
      appOverview_layout,
    }
  }
end)

local function createWidget(client)
  local cl_w, cl_h = gears.surface.get_size(gears.surface(client.content))

  local widget = base.make_widget()

  local title = wibox.widget {
    widget = wibox.container.background,
    opacity = 0,
    bg = "#4f6be3",
    shape = function (cr,w,h)
      gears.shape.rounded_rect(cr,w,h,dpi(5))
    end,
    {
      widget = wibox.container.margin,
      left = dpi(5),
      right = dpi(5),
      top = dpi(1),
      bottom = dpi(1),
      {
        widget = wibox.widget.textbox(client.name),
        wrap = "char",
        forced_height = dpi(20)
      }
    }
  }

  local bg = wibox.widget {
    layout = wibox.layout.stack,
    {
      widget = wibox.container.margin,
      left = dpi(10),
      right = dpi(10),
      top = dpi(10 / (cl_w/cl_h)),
      bottom = dpi(10 / (cl_w/cl_h)),
      {
        id = "container",
        widget = require("widget.clickable-container"),
        shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
        border_width = dpi(2),
        border_strategy = "inner",
        border_color = "#3d3d3d",
        widget
      }
    },
    {
      widget = wibox.container.place,
      halign = "center",
      valign = "top",
      {
        widget = wibox.container.margin,
        top = dpi(-7),
        {
          widget = awful.widget.clienticon(client),
          forced_width = dpi(50),
          forced_height = dpi(50),
        }
      },
    },
    {
      widget = wibox.container.place,
      halign = "center",
      valign = "bottom",
      title
    },
  }

  gears.table.crush(bg._private, {
    width = cl_w,
    height = cl_h,
    get_size = function (self)
      return self.width, self.height
    end,
    set_size = function (self,w,h)
      w = w == nil and self.width or w
      h = h == nil and self.height or h
      self.width = w
      self.height = h
    end,
    client = {
      get_content_size = function ()
        return cl_w, cl_h
      end,
      content = gears.surface(client.content)
    }
  })

  function widget:fit(ctx, width, height)
    return width, height
  end
  function widget:draw(ctx, cr, width, height)
    local tmp = gears.surface(client.content)
    cr:scale(width / cl_w, height / cl_h)
    cr:set_source_surface(tmp,0,0)
    local pat = cr:get_source()
    pat:set_filter("BILINEAR")
    cr:paint()
    tmp:finish()
  end

  widget:connect_signal("mouse::enter",function ()
    local container = bg:get_children_by_id("container")[1]
    container.border_color = "#FFF"
    title.opacity = 1
    bg:emit_signal("widget::redraw_needed")
  end)
  widget:connect_signal("mouse::leave",function ()
    local container = bg:get_children_by_id("container")[1]
    container.border_color = "#3d3d3d"
    title.opacity = 0
    bg:emit_signal("widget::redraw_needed")
  end)
  widget:connect_signal("button::press",function (_,_,_,btn)
    if btn == 1 then
      client:activate()
      _G.awesome.emit_signal("module::app-overview")
    end
    if btn == 2 then
      appOverview_layout:remove(bg._private.index)
      client:kill()
    end
  end)

  return bg
end

function appOverview_layout:layout(_, width, height)
  local result = {}
  local wdgs = self._private.widgets
  local widgetsPerRow = #wdgs > 2 and math.ceil(#wdgs / 2) or 2
  widgetsPerRow = widgetsPerRow >= 5 and widgetsPerRow - 1 or widgetsPerRow

  local rowHeight = height / math.ceil(#wdgs / widgetsPerRow)
  local pos = { x = 0, y = 0 }

  local rowsWidth = {}
  for i,v in ipairs(wdgs) do
    v._private.index = i
    local w,h = v._private.client.get_content_size()
    local winRatio = w / h
    h = h / screen.geometry.height * rowHeight
    w = h * winRatio
    v._private:set_size(w, h)

    pos.x = pos.x + w
    rowsWidth[pos.y] = pos.x
    if i % widgetsPerRow == 0 then
      pos.x = 0
      pos.y = pos.y + rowHeight
    end
  end
  pos.x = 0
  pos.y = 0
  for i,v in ipairs(wdgs) do
    local w,h = v._private:get_size()
    local resize = 0
    if rowsWidth[pos.y] > width then
      resize = width / rowsWidth[pos.y]
      w = w * resize
      h = h * resize
    end
    table.insert(result, base.place_widget_at(
      v,
      rowsWidth[pos.y] > width and pos.x or pos.x + width / 2 - rowsWidth[pos.y] / 2,
      pos.y + rowHeight / 2 - h / 2,
      w,
      h
    ))
    pos.x = pos.x + w
    if i % widgetsPerRow == 0 then
      pos.x = 0
      pos.y = pos.y + rowHeight
    end
  end

  return result
end

function appOverview_layout:remove(index)
  if not index or index < 1 or index > #self._private.widgets then return false end

  table.remove(self._private.widgets, index)

  self:emit_signal("widget::layout_changed")

  return true
end

_G.awesome.connect_signal("module::app-overview",function ()
  screen.appOverview.visible = not screen.appOverview.visible
  if screen.appOverview.visible then
    screen.top_panel.bg = "#222"
  else
    screen.top_panel.bg = beautiful.top_panel_bg
  end

  appOverview_layout:reset()
  for i,c in pairs(clients()) do
    appOverview_layout:add(createWidget(c))
  end
end)

_G.client.connect_signal("manage", function (client)
  if screen.appOverview.visible then
    appOverview_layout:add(createWidget(client))
  end
end)