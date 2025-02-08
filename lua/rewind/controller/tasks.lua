local rewind = require("rewind")
local M = {}

function M.add(board_title, list_title, input)
	if rewind.controller.add_data(input, "tasks", board_title, list_title) then
		rewind.util.update_content("tasks")
	end
end

function M.delete(board_title, list_title, task_title)
	if rewind.controller.delete_data("task", board_title, list_title, task_title) then
		rewind.util.update_content("tasks")
	end
end

-- function M.reload()
-- 	rewind.util.update_content(rewind.state.buf.tasks, rewind.state.get_current("task"))
-- end

function M.default_value(title)
	return {
		title = title,
		state = "TODO",
		date = "UNDEFINED",
	}
end

return M
