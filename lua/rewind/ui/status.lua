local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	util.win.set(key)
end

function M.close_window(key, skip)
	if not skip then
		local _, status = util.get_cursor_content(key)
		if status then
			command.update_item("tasks", { key = "state", data = status })
			util.tasks.init_tags_color()
		end
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
