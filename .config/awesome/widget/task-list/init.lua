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
    id = 'task_widget',
    hasGroup = false,
    widget = require("widget.clickable-container"),
    {
      id            = 'background_role',
      widget        = wibox.container.background,
      {
        layout = wibox.layout.align.vertical,
        nil,
        {
          widget = wibox.container.place,
          halign = 'center',
          {
            widget  = wibox.container.margin,
            margins = {
              left = dpi(7),
              right = dpi(7),
              top = dpi(5),
              bottom = dpi(3),
            },
            {
              id = "icon_role",
              widget = wibox.widget.imagebox
            }
          }
        },
        {
          id = "underline_role",
          layout = wibox.layout.flex.horizontal,
          spacing = dpi(2),
          {
            id = 'group_role',
            widget = wibox.container.background,
            forced_height = dpi(2),
            bg = '#ff000000'
          }
        },
      },
    },
    create_callback = function (self,client,index,clients)
      local icon_widget = self:get_children_by_id('icon_role')[1]

      if client.icon then icon_widget.image = client.icon
      else icon_widget.image = require('themes.icons').app_icon end

      -- Create group by app (class)
      local group = {}
      for i,c in pairs(clients) do
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

      createPopup(self,client)

    end,
    update_callback = function (self,client,index,clients)
      local underline_layout = self:get_children_by_id('underline_role')[1]
      local group_widget = self:get_children_by_id('group_role')[1]

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

          underline_layout:add(wibox.widget {
            id = 'group_role',
            widget = wibox.container.background,
            forced_height = dpi(2),
            bg = (v == idFocused) and colors[1] or colors[2]
          })
        end
        self.visible = true
        self.bg = ((index == idFocused) or not isFocusInGroup) and
        beautiful.transparent or beautiful.tasklist_bg_focus
        return
      end
      self.hasGroup = false
      self.bg = beautiful.transparent
      self.visible = true
      self.opacity = 1
      underline_layout:reset()
      underline_layout:add(group_widget)
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