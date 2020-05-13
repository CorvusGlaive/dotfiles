local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local capi = {button = _G.button}
local beautiful = require("beautiful")

local function create_buttons(buttons, object)
    if buttons then
      local btns = {}
      for _, b in ipairs(buttons) do
        -- Create a proxy button object: it will receive the real
        -- press and release events, and will propagate them to the
        -- button object the user provided, but with the object as
        -- argument.
        local btn = capi.button {modifiers = b.modifiers, button = b.button}
        btn:connect_signal(
          'press',
          function()
            b:emit_signal('press', object)
          end
        )
        btn:connect_signal(
          'release',
          function()
            b:emit_signal('release', object)
          end
        )
        btns[#btns + 1] = btn
      end

      return btns
    end
  end



local function list_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
      local cache = data[o]
      local ib, cb, tb, cbm, bgb, tbm, ibm, tt, l, ll, bg_clickable
      if cache then
        ib = cache.ib
        tb = cache.tb
        bgb = cache.bgb
        tbm = cache.tbm
        ibm = cache.ibm
        tt  = cache.tt
      else
        ib = wibox.widget.imagebox()
        tb = wibox.widget.textbox()

        bgb = wibox.container.background()
        tbm = wibox.container.margin(tb, dpi(4), dpi(4))
        ibm = wibox.container.margin(ib, dpi(4), dpi(4), dpi(4), dpi(4))
        l = wibox.layout.fixed.horizontal()


        -- All of this is added in a fixed widget
        l:fill_space(true)
        l:add(ibm)
        l:add(tbm)

        -- And all of this gets a background
        bgb:set_widget(require("widget.clickable-container")(l))
        l:buttons(create_buttons(buttons, o))

        -- Tooltip to display whole title, if it was truncated
        tt = awful.tooltip({
          objects = {tb},
          mode = 'outside',
          align = 'bottom',
          delay_show = 1,
        })

        data[o] = {
          ib = ib,
          tb = tb,
          bgb = bgb,
          tbm = tbm,
          ibm = ibm,
          tt  = tt
        }
      end

      local text, bg, bg_image, icon, args = label(o, tb)
      args = args or {}

      -- The text might be invalid, so use pcall.
      if text == nil or text == '' then
        tbm:set_margins(0)
      else
        -- truncate when title is too long
        local textOnly = text:match('</b>(.-)</span>') or text:match('>(.-)<')
        tt:set_text(textOnly)
        tt:add_to_object(tb)

        if not tb:set_markup_silently(text) then
          tb:set_markup('<i>&lt;Invalid text&gt;</i>')
        end
      end
      -- if w.minimized then

      bgb:set_bg(bg)

      if type(bg_image) == 'function' then
        -- TODO: Why does this pass nil as an argument?
        bg_image = bg_image(tb, o, nil, objects, i)
      end
      bgb:set_bgimage(bg_image)
      if icon then
        ib.image = gears.surface(icon)
      else
        ibm:set_margins(0)
      end

      bgb.shape = args.shape
      bgb.shape_border_width = args.shape_border_width
      bgb.shape_border_color = args.shape_border_color

      local constraint_bg = wibox.container.constraint(bgb,"max",150,nil)

      w:add(constraint_bg)
    end
  end

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
    -- return awful.widget.tasklist(
    --     s,
    --     awful.widget.tasklist.filter.currenttags,
    --     tasklist_buttons,
    --     {
    --       -- shape_border_width = 1,
    --       -- shape_border_color = '#777777',
    --       shape        = function(cr,w,h)gears.shape.rounded_rect(cr,w,h,4)end,
    --     },
    --     list_update,
    --     {
    --         -- spacing = 10,
    --         -- spacing_widget = {
    --         --     {
    --         --         forced_width = 5,
    --         --         shape        = gears.shape.circle,
    --         --         widget       = wibox.widget.separator
    --         --     },
    --         --     valign = 'center',
    --         --     halign = 'center',
    --         --     widget = wibox.container.place,
    --         -- },
    --         layout  = wibox.layout.fixed.horizontal
    --     }
    -- )
  local focusWithin = false
  local timerDelay = 0.6
  local peekview_showTimer = gears.timer {timeout = timerDelay, single_shot = true}
  local peekview_hideTimer = gears.timer {timeout = timerDelay, single_shot = true}
  local peekview_widget = wibox.widget.base.make_widget()
  local peekview_popup = awful.popup {
    widget = peekview_widget,
    border_color = '#6b6b6b',
    border_width = 1,
    ontop        = true,
    preferred_positions = 'top',
    preferred_anchors   = 'middle',
    shape        = gears.shape.rounded_rect,
    visible      = false,
    offset = {y = dpi(-5)}
  }

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
                left = dpi(5),
                right = dpi(5),
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

        -- Hide widget if there is already the same app is running now (Create group by app)
        local idxs = {}
        for i,c in pairs(clients) do
          if c.class == client.class then
            table.insert(idxs,i)
          end
        end
        -- Second condition needs for remain icon in case of Awesome restart
        if #idxs >= 2 and idxs[1] ~= index then self.visible = false end

        self:connect_signal("mouse::enter",function ()
          if client.minimized then return end
          peekview_showTimer:again()
          local function createPeekviewWdg(c)
            local cw,ch = gears.surface.get_size(gears.surface(c.content))
            local h = dpi(200)   -- widget height
            local ratio = math.min(s.geometry.width / (s.geometry.height - beautiful.top_panel_height),
                                   cw / ch)
            local w = h * ratio
                  w = math.floor(w)
            peekview_widget = wibox.widget.base.make_widget()
            peekview_widget.fit = function(self,width,height)
              return w,h
            end
            peekview_widget.draw = function(peekview_popup,peekview_widget,cr,width,height)
              local a = 1
              local sx,sy,tx,ty
              if cw > ch then
                sx = a * w / cw
                sy = sx
              else
                sy = a * h / ch
                sx = sy
              end

              tx = (w - sx * cw) / 2
              ty = (h - sy * ch) / 2

              local tmp = gears.surface(c.content)
              cr:translate(tx, ty)
              cr:scale(sx,sy)
              cr:set_source_surface(tmp, 0, 0)
              cr:paint()
              tmp:finish()
            end
            peekview_popup:connect_signal('mouse::enter',function()
              if peekview_hideTimer.started then peekview_hideTimer:stop() end
            end)
            peekview_popup:connect_signal('mouse::leave',function()
              peekview_hideTimer:again()
            end)
            peekview_widget:connect_signal('button::press',function()
              c:activate()
              _G.mouse.coords {
                x = c.x + c.width / 2,
                y = c.y + c.height / 2
              }
              peekview_popup.visible = false
            end)
            return wibox.widget {
              layout = wibox.layout.fixed.vertical,
              {
                widget = wibox.container.constraint,
                strategy = 'max',
                width = dpi(w - 5),
                height = dpi(25),
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
              peekview_widget,
            }
          end
          local peekview_layout = wibox.widget {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(10),
            spacing_widget =  {
              forced_width = dpi(1),
              color = "#d8d8d8",
              orientation = 'vertical',
              widget = wibox.widget.separator,
            },
          }

          for _,c in pairs(_G.screen[_G.mouse.screen]:get_clients(false)) do
            if client.class == c.class then
              peekview_layout:add(createPeekviewWdg(c))
            end
          end
          peekview_popup.widget = wibox.widget {
            widget = wibox.container.background,
            peekview_layout
          }
          end
        )

        self:connect_signal("mouse::leave",function (w)
          if peekview_showTimer.started and not focusWithin then peekview_showTimer:stop() end
          if not focusWithin then peekview_hideTimer:again() end
          if not peekview_showTimer.started and focusWithin then peekview_showTimer.timeout = 0 end

        end)
        self:connect_signal("button::press",function (w)
          local isTimerStarted = peekview_showTimer.started
          local toggleClientMin = function () client:activate { context = "tasklist", action = "toggle_minimization" } end
          if isTimerStarted and w.hasGroup then
            peekview_showTimer:stop()
            peekview_popup:move_next_to(s.top_panel)
            local curWidgetGeo = _G.mouse.current_widget_geometry
            peekview_popup.x  = curWidgetGeo.x - peekview_popup.width / 2 + curWidgetGeo.width / 2
            peekview_popup.visible = true
            return
          end
          if isTimerStarted and not w.hasGroup then toggleClientMin() peekview_showTimer:stop() return end
          if not isTimerStarted and not w.hasGroup then toggleClientMin() peekview_popup.visible = false return end
          -- if not isTimerStarted and w.hasGroup and peekview_popup.visible then client.minimized = false return end
        end)


      end,
      update_callback = function (self,client,index,clients)
        local underline_layout = self:get_children_by_id('underline_role')[1]
        local group_widget = self:get_children_by_id('group_role')[1]

        local idFocused = 0
        local idxs = {}

        for i,c in pairs(clients) do
          if c.active then idFocused = i end
          if client.class == c.class then
            table.insert(idxs,i)
          end
        end

        if #idxs >= 2 then
          if idxs[1] == index then
            self.hasGroup = true
            local c = false
            for i,v in pairs(idxs) do
              c = (v == idFocused) and true or c
            end
            self.visible = true
            self.bg = ((index == idFocused) or not c) and
            beautiful.transparent or beautiful.tasklist_bg_focus
          end

          underline_layout:reset()
          for i,v in pairs(idxs) do
            local c = {'#fff3','#ff0000',beautiful.bg_focus}
            local wdg = wibox.widget {
              id = 'group_role',
              widget = wibox.container.background,
              forced_height = dpi(2),
              -- bg = c[i]
              bg = (v == idFocused) and c[3] or c[1]
            }
            -- group_widget.bg = '#ffffff'
            underline_layout:add(wdg)
          end
        else
          self.bg = beautiful.transparent
          self.visible = true
          self.opacity = 1
          underline_layout:reset()
          underline_layout:add(group_widget)
        end
      end
    },
  }
  taskList:connect_signal('mouse::enter',function ()
    focusWithin = true
  end)
  taskList:connect_signal('mouse::leave',function ()
    focusWithin = false
    peekview_showTimer.timeout = timerDelay
  end)
  peekview_showTimer:connect_signal("timeout",function()
    peekview_popup:move_next_to(s.top_panel)
    local curWidgetGeo = _G.mouse.current_widget_geometry
    peekview_popup.x  = curWidgetGeo.x - peekview_popup.width / 2 + curWidgetGeo.width / 2
    peekview_popup.visible = true end)
  peekview_hideTimer:connect_signal("timeout",function() peekview_popup.visible = false end)
  return taskList
end



return TaskList