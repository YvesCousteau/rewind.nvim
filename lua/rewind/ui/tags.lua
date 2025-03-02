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
		local tag = util.get_cursor_content(key)
		if tag then
			command.update_item("tasks", { key = "tags", data = tag })
		end
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
