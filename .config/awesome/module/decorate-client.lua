local awful = require('awful')

local function renderClient(client, mode)
  if client.skip_decoration or (client.rendering_mode == mode) then
    return
  end
  client.rendering_mode = mode

  if mode == "maximized" then client.maximized = true
  elseif mode == "tiled" then client.maximized = false end

  -- Changes client shape in maximized layout to rectangle without borders
  -- if mode == "maximized" and client == _G.client.focus  then
    -- debugNotif('MAX','client is gonna be MAX','green')
    -- client.border_width = 0
    -- client.shape = function(cr, w, h)
    --   gears.shape.rectangle(cr, w, h)
    -- end
    -- return
  -- elseif mode == "tiled" then
    -- debugNotif('TILED','client is gonna be TILED','red')
    -- client.border_width = beautiful.border_width
    -- client.shape = function(cr, w, h)
    --   gears.shape.rounded_rect(cr, w, h, 8)
    -- end
  -- end

end

local function changesOnScreen(currentScreen)
  local tagIsMax = currentScreen.selected_tag ~= nil and currentScreen.selected_tag.layout == awful.layout.suit.max
  if #currentScreen.clients == 0 then return end
  if #currentScreen.clients == 1 then
    renderClient(currentScreen.clients[1],"maximized")
    return
  end
  for _, client in pairs(currentScreen.clients) do
    if not client.skip_decoration and not client.hidden then
      renderClient(client, tagIsMax and "maximized" or "tiled")
    end
  end
end

local function clientCallback(client)
    if not client.skip_decoration and client.screen then
      local screen = client.screen
      changesOnScreen(screen)
    end
end

local function tagCallback(tag)
  if tag.screen then
    local screen = tag.screen
    changesOnScreen(screen)
  end
end


_G.client.connect_signal('manage', clientCallback)

_G.client.connect_signal('unmanage', clientCallback)

_G.client.connect_signal('property::hidden', clientCallback)

_G.client.connect_signal('property::minimized', clientCallback)


_G.tag.connect_signal('property::selected', tagCallback)

_G.tag.connect_signal('property::layout', tagCallback)
