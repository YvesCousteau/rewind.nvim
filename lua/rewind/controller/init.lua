local rewind = require("rewind")
local M = {}

M.boards = rewind.lazy_load("rewind.controller.boards")
M.lists = rewind.lazy_load("rewind.controller.lists")
M.tasks = rewind.lazy_load("rewind.controller.tasks")
M.help = rewind.lazy_load("rewind.controller.help")

local function find_data(boards, type, board_title, list_title, task_title)
	if type == "boards" then
		return nil, boards
	elseif board_title then
		for board_index, board in ipairs(boards) do
			if board.title and board.title == board_title then
				if type == "board" then
					return board_index, board
				elseif board.lists then
					if type == "lists" then
						return nil, board.lists
					elseif list_title then
						for list_index, list in ipairs(board.lists) do
							if list.title and list.title == list_title then
								if type == "list" then
									return list_index, list
								elseif list.tasks then
									if type == "tasks" then
										return nil, list.tasks
									elseif task_title then
										for task_index, task in ipairs(list.tasks) do
											if task.title and task.title == task_title then
												if type == "task" then
													return task_index, task
												else
													print("Invalid type for task level")
													return nil, nil
												end
											end
										end
									else
										print("Invalid type for list level")
										return nil, nil
									end
								else
									return nil, nil
								end
							end
						end
					else
						print("Invalid type for board level")
						return nil, nil
					end
				else
					return nil, nil
				end
			end
		end
	else
		print("No matching data found")
		return nil, nil
	end
end

function M.get_data(type, board_title, list_title)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, item = find_data(boards, type, board_title, list_title)
	if not item then
		return nil
	end
	return item
end

function M.update_data(input, type, board_title, list_title, task_title)
	if not input or input == "" then
		return nil
	end

	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, item = find_data(boards, type, board_title, list_title, task_title)
	if not item then
		return nil
	end

	item.title = input

	local success = rewind.util.save_json_file(rewind.config.options.file_path, boards)
	if not success then
		return nil
	end
	return true
end

function M.add_data(input, type, board_title, list_title)
	if not input or input == "" then
		return nil
	end

	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, item = find_data(boards, type, board_title, list_title)
	if not item then
		return nil
	end
	table.insert(item, M[type].default_value(input))

	local success = rewind.util.save_json_file(rewind.config.options.file_path, boards)
	if not success then
		return nil
	end
	return true
end

function M.delete_data(type, board_title, list_title, task_title)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, parent = find_data(boards, type .. "s", board_title, list_title, task_title)
	if not parent then
		return nil
	end

	local index, item = find_data(boards, type, board_title, list_title, task_title)
	if not item then
		return nil
	end
	table.remove(parent, index)

	local success = rewind.util.save_json_file(rewind.config.options.file_path, boards)
	if not success then
		return nil
	end
	return true
end

return M
