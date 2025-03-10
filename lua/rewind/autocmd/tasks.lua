local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tasks"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)

		local _, current_task = util.get_cursor_content("tasks")
		if current_task then
			util.set_var("current_task", current_task)
		end
	end)
end

return M
