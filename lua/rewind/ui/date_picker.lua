local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	util.win.set(key)
end

function M.close_window(key)
	if not skip then
		local _, current_task = util.get_cursor_content("tasks")
		local date = util.date_picker.get_formated()
		if current_task and date then
			print(current_task.title .. " with " .. date)
		end
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
