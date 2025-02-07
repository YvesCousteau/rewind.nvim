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
	if rewind.controller.update_data(input, "task", board_title, list_title, task_title) then
		local current_tasks = rewind.state.set_current("tasks", M.get(board_title, list_title))
		rewind.util.update_contents(rewind.state.buf.tasks, current_tasks)
	end
end

function M.add(board_title, list_title, input)
	if rewind.controller.add_data(input, "tasks", board_title, list_title) then
		local current_tasks = rewind.state.set_current("tasks", M.get(board_title, list_title))
		rewind.util.update_contents(rewind.state.buf.tasks, current_tasks)
	end
end

function M.delete(board_title, list_title, task_title)
	if rewind.controller.delete_data("task", board_title, list_title, task_title) then
		local current_tasks = rewind.state.set_current("tasks", M.get(board_title, list_title))
		rewind.util.update_contents(rewind.state.buf.tasks, current_tasks)
	end
end

function M.default_value(title)
	return {
		title = title,
		state = "TODO",
		date = "UNDEFINED",
	}
end

return M
