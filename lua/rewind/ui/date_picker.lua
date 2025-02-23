local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	util.date_picker.set()
	util.win.set(key)
end

function M.close_window(key)
	local current_task = util.get_cursor_content("tasks").title
	local date = util.date_picker.get_formated()
	if current_task and date then
		print(current_task .. " with " .. date)
	end
	util.win.close(key)
end

return M
