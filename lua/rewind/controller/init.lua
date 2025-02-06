local rewind = require("rewind")
local M = {}

M.boards = rewind.lazy_load("rewind.controller.boards")
M.lists = rewind.lazy_load("rewind.controller.lists")
M.tasks = rewind.lazy_load("rewind.controller.tasks")
M.help = rewind.lazy_load("rewind.controller.help")

function M.get_data(type, board_title, list_title)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end
	if type == "boards" then
		return boards
	else
		for _, board in ipairs(boards) do
			if board.title and board.title == board_title and board.lists and #board.lists > 0 then
				if type == "lists" then
					return board.lists
				else
					for _, list in ipairs(board.lists) do
						if list.title and list.title == list_title and list.tasks and #list.tasks > 0 then
							if type == "tasks" then
								return list.tasks
							end
						end
					end
				end
			end
		end
	end
end

function M.update_data(input, type, board_title, list_title, task_title)
	if not input or input == "" then
		print("Error: Input not valid")
		return nil
	end

	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local updated = false
	for _, board in ipairs(boards) do
		if board.title == board_title then
			if type == "board" then
				board.title = input
				updated = true
				break
			elseif type == "list" or type == "task" then
				for _, list in ipairs(board.lists or {}) do
					if list.title == list_title then
						if type == "list" then
							list.title = input
							updated = true
							break
						elseif type == "task" then
							for _, task in ipairs(list.tasks or {}) do
								if task.title == task_title then
									task.title = input
									updated = true
									break
								end
							end
						end
						if updated then
							break
						end
					end
				end
			end
			if updated then
				break
			end
		end
	end
	if updated then
		local success = rewind.util.save_json_file(rewind.config.options.file_path, boards)
		if not success then
			return nil
		end
	else
		print("Error: Item not found for update")
	end
	return true
end

return M
