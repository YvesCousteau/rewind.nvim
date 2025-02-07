local rewind = require("rewind")
local M = {}

M.boards = rewind.lazy_load("rewind.controller.boards")
M.lists = rewind.lazy_load("rewind.controller.lists")
M.tasks = rewind.lazy_load("rewind.controller.tasks")
M.help = rewind.lazy_load("rewind.controller.help")

local function find_data(boards, type, board_title, list_title, task_title)
	if type == "boards" then
		return boards
	elseif board_title then
		for board_index, board in ipairs(boards) do
			if board.title and board.title == board_title then
				if type == "board" then
					return board
				elseif board.lists and #board.lists > 0 then
					if type == "lists" then
						return board.lists
					elseif list_title then
						for list_index, list in ipairs(board.lists) do
							if list.title and list.title == list_title then
								if type == "list" then
									return list
								elseif list.tasks and #list.tasks > 0 then
									if type == "tasks" then
										return list.tasks
									elseif task_title then
										for task_index, task in ipairs(list.tasks) do
											if task.title and task.title == task_title then
												if type == "task" then
													return task
												else
													return nil
												end
											end
										end
									else
										return nil
									end
								else
									return nil
								end
							end
						end
					else
						return nil
					end
				else
					return nil
				end
			end
		end
	else
		return nil
	end
end

function M.get_data(type, board_title, list_title)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	return find_data(boards, type, board_title, list_title)
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

function M.add_data(input, type, board_title, list_title)
	if not input or input == "" then
		print("Error: Input not valid")
		return nil
	end

	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local updated = false
	if type == "board" then
		table.insert(boards, { title = input })
		updated = true
	else
		for _, board in ipairs(boards) do
			if board.title == board_title and board.lists and #board.lists > 0 then
				if type == "list" then
					table.insert(board.lists, { title = input })
					updated = true
					break
				else
					for _, list in ipairs(board.lists or {}) do
						if list.title == list_title and list.tasks and #list.tasks > 0 then
							if type == "task" then
								table.insert(list.tasks, { title = input })
								updated = true
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

function M.delete_data(type, board_title, list_title, task_title)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local updated = false
	for board_index, board in ipairs(boards) do
		if board.title == board_title then
			if type == "board" then
				table.remove(boards, board_index)
				updated = true
				break
			elseif type == "list" or type == "task" then
				for list_index, list in ipairs(board.lists or {}) do
					if list.title == list_title then
						if type == "list" then
							table.remove(board.lists, list_index)
							updated = true
							break
						elseif type == "task" then
							for task_index, task in ipairs(list.tasks or {}) do
								if task.title == task_title then
									table.remove(list.tasks, task_index)
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
