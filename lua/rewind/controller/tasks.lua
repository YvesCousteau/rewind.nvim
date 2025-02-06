local rewind = require("rewind")
local M = {}

function M.get(board_title, list_title)
	local tasks = rewind.controller.get_data("tasks", board_title, list_title)
	if tasks and #tasks > 0 then
		local tasks_title = {}
		for _, task in ipairs(tasks) do
			table.insert(tasks_title, task.title)
		end
		return tasks_title
	end
	return {}
end

function M.set(board_title, list_title, task_title, input)
	rewind.controller.update_data(input, "tasks", board_title, list_title, task_title)
end

return M
