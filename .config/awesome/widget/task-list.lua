local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local capi = {button = _G.button}

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

        ib.forced_width = 15
        ib.forced_height = 15

        bgb = wibox.container.background()
        tbm = wibox.container.margin(tb, dpi(4), dpi(4))
        ibm = wibox.container.margin(ib, dpi(4), dpi(0), dpi(6), dpi(4))
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
        ib.image = icon
      else
        ib.forced_height = 0
        ib.forced_width = 0
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
                             if c == _G.client.focus then
                                 c.minimized = true
                             else
                                 c:emit_signal(
                                     "request::activate",
                                     "tasklist",
                                     {raise = true}
                                 )
                             end
                         end),
    awful.button({ }, 2, function(c)
                             c.kill(c)
                         end),
    awful.button({ }, 3, function()
                             awful.menu.client_list({ theme = { width = 250 } })
                         end),
    awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                         end),
    awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                         end)
)

local TaskList = function(s)
    return awful.widget.tasklist(
        s,
        awful.widget.tasklist.filter.currenttags,
        tasklist_buttons,
        {
          -- shape_border_width = 1,
          -- shape_border_color = '#777777',
          shape        = function(cr,w,h)gears.shape.rounded_rect(cr,w,h,4)end,
        },
        list_update,
        {
            -- spacing = 10,
            -- spacing_widget = {
            --     {
            --         forced_width = 5,
            --         shape        = gears.shape.circle,
            --         widget       = wibox.widget.separator
            --     },
            --     valign = 'center',
            --     halign = 'center',
            --     widget = wibox.container.place,
            -- },
            layout  = wibox.layout.fixed.horizontal
        }
    )
end



return TaskList