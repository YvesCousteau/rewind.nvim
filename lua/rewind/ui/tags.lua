local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	util.win.set(key)
	util.tags.init_tags_color()
end

function M.close_window(key, skip)
	if not skip then
		local _, tag = util.get_cursor_content(key)
		local _, task = util.get_cursor_content("tasks")
		if tag and task and task.tags then
			table.insert(task.tags, tag)
			command.update_item("tasks", { key = "tags", data = task.tags })
		end
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
