local wibox = require('wibox')
local beautiful = require('beautiful')

local function build(widget,bg_focus,bg_normal)
	local container = wibox.widget {
		widget,
		bg_focus = bg_focus,
		bg_normal = bg_normal,
		widget = wibox.container.background
	}
	local old_cursor, old_wibox

	container:connect_signal(
		'mouse::enter',
		function(...)
			if container.bg_normal == nil or bg_normal == nil then
				container.bg_normal = container.bg or beautiful.transparent
			end
			container.bg = container.bg_focus or "#ffffff10"
			-- Hm, no idea how to get the wibox from this signal's arguments...
			local w = _G.mouse.current_wibox
			if w then
				old_cursor, old_wibox = w.cursor, w
				w.cursor = 'hand2'
			end
			if container.on_hover then
				container.on_hover(container,...)
			end
		end
	)

	container:connect_signal(
		'mouse::leave',
		function(...)
			container.bg = container.bg_normal or "00000000"
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
			if container.on_leave then
				container.on_leave(container,...)
			end
		end
	)

	container:connect_signal(
		'button::press',
		function(...)
			-- container.bg = "#ffffff15"
			if container.on_press then
				container.on_press(container,...)
			end
		end
	)

	container:connect_signal(
		'button::release',
		function(...)
			-- container.bg = "#ffffff10"
			if container.on_release then
				container.on_release(container,...)
			end
		end
	)

	return container
end

return build
