local M = {}
local rewind = require("rewind")
local util = rewind.util

function M.open_window(key)
	util.win.set(key)

	local custom_name = "2sexe"
	-- Safely get the current list
	success, current_list = pcall(util.get_cursor_content, "lists")
	if success and current_list then
		custom_name = custom_name .. current_list

		-- Safely get the current task
		success, current_task = pcall(util.get_cursor_content, "tasks")
		if success and current_task then
			custom_name = custom_name .. current_task
		end
	end
	util.change_window_title(key, custom_name)
end

function M.close_window(key, skip)
	util.win.close(key)
end

return M
