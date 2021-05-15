local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local createPopup = require('widget.task-list.peekview')

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
                            --  c:activate { context = "tasklist", action = "toggle_minimization" }
                         end),
    awful.button({ }, 2, function(c)
                             c.kill(c)
                         end),
    awful.button({ }, 3, function()
                             awful.menu.client_list({ theme = { width = 250, height = 20 } })
                         end),
    awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                         end),
    awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                         end)
)

local TaskList = function(s)

  local function group_widget(bg)
    local dotSize = dpi(3)
    return wibox.widget {
      id = "group_role",
      widget = wibox.container.background,
      forced_height = dpi(dotSize + 2),
      forced_width = dpi(dotSize),
      shape = gears.shape.circle,
      bg = bg or "#f00",
    }
  end
  local taskList = awful.widget.tasklist {
  screen   = s,
  filter   = awful.widget.tasklist.filter.currenttags,
  buttons  = tasklist_buttons,
  layout   = {
    spacing = dpi(1),
    layout  = wibox.layout.fixed.horizontal
  },
  -- -- Notice that there is *NO* wibox.wibox prefix, it is a template,
  -- -- not a widget instance.
  widget_template = {
    hasGroup = false,
    widget = require("widget.clickable-container"),
    bg_focus = beautiful.transparent,
    {
      widget = wibox.container.margin,
      left = dpi(5),
      right = dpi(5),
      {
        layout = wibox.layout.stack,
        fill_space = true,
        {
          --Background
          widget = wibox.container.margin,
          margins = dpi(2),
          {
            widget = wibox.container.background,
            shape = function (cr, w, h)
              local rate = math.floor(w) ~= math.floor(h) and 8 or 2
              gears.shape.squircle(cr, w, h, rate)
            end,
            {
              id = "bg_role",
              widget = wibox.container.background,
            }
          }
        },
        {
          --Group indicator
          widget = wibox.container.margin,
          right = dpi(-2),
          {
            widget = wibox.container.place,
            valign = "center",
            halign = "right",
            -- content_fill_vertical = true,
            -- forced_width = dpi(25),
          {
            id = "underline_role",
            layout = wibox.layout.flex.vertical,
            spacing = dpi(1),
          }
          }
        },
        {
          --Icon widget
          widget = wibox.container.place,
          halign = "center",
          {
            widget = wibox.container.margin,
            margins = dpi(4),
            -- awful.widget.clienticon
            {
              id = "icon_role",
              widget = wibox.widget.imagebox
            }
          }
        },

      },

    },
    create_callback = function (self,client,index,clients)
      local icon_widget = self:get_children_by_id('icon_role')[1]
      local bg = self:get_children_by_id("bg_role")[1]

      if client.icon then icon_widget.image = client.icon
      else icon_widget.image = require('themes.icons').app_icon end

      -- Create group by app (class)
      local group = {}
      local idFocused
      for i,c in pairs(clients) do
        if c.active then idFocused = i end
        if c.class == client.class  then
          table.insert(group,i)
        end
      end
      -- Move the created widget to its group, if it exists
      if #group > 1 and index ~= group[1] and (index - group[#group-1] ~= 1) then
        for i = #clients - 1 ,group[#group - 1] + 1 ,-1 do
          client:swap(clients[i])
        end
      end
      -- Second condition needs for remain icon in case of Awesome restart
      if #group > 1 and index ~= group[1] then self.visible = false end

      bg.bg = (index == idFocused) and beautiful.tasklist_bg_focus or beautiful.transparent
      createPopup(self,client)

    end,
    update_callback = function (self,client,index,clients)
      local underline_layout = self:get_children_by_id('underline_role')[1]
      local bg = self:get_children_by_id('bg_role')[1]

      local idFocused = 0
      local isFocusInGroup = false
      local group = {}

      local colors = {beautiful.bg_focus, '#fff3'}

      for i,c in pairs(clients) do
        if c.active then idFocused = i end
        if client.class == c.class then
          table.insert(group,i)
        end
      end
      if #group > 1 then
        if index ~= group[1] then self.visible = false return end
        self.hasGroup = true
        underline_layout:reset()

        for _,v in pairs(group) do
          isFocusInGroup = (v == idFocused) and true or isFocusInGroup

          underline_layout:add(group_widget(
            (v == idFocused) and colors[1] or colors[2]
          ))
        end
        self.visible = true
        bg.bg = isFocusInGroup and
        beautiful.tasklist_bg_focus or beautiful.transparent
        return
      end
      self.hasGroup = false
      bg.bg = (index == idFocused) and beautiful.tasklist_bg_focus or beautiful.transparent
      self.visible = true
      underline_layout:reset()
    end
    },
  }
  taskList:connect_signal('mouse::enter',function ()
    _G.awesome.emit_signal('widget::tasklist_focus',true)
  end)
  taskList:connect_signal('mouse::leave',function ()
    _G.awesome.emit_signal('widget::tasklist_focus',false)
  end)

  return taskList
end



return TaskList