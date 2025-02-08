local rewind = require("rewind")
local M = {}

M.boards = rewind.lazy_load("rewind.controller.boards")
M.lists = rewind.lazy_load("rewind.controller.lists")
M.tasks = rewind.lazy_load("rewind.controller.tasks")
M.help = rewind.lazy_load("rewind.controller.help")

local function find_data(content_type, content)
	local current_board = rewind.state.get_current("board")
	local current_list = rewind.state.get_current("list")
	local current_task = rewind.state.get_current("task")

	if content_type == "boards" then
		return nil, content
	elseif current_board then
		for board_index, board in ipairs(content) do
			if board.title and board.title == current_board then
				if content_type == "board" then
					return board_index, board
				elseif board.lists then
					if content_type == "lists" then
						return nil, board.lists
					elseif current_list then
						for list_index, list in ipairs(board.lists) do
							if list.title and list.title == current_list then
								if content_type == "list" then
									return list_index, list
								elseif list.tasks then
									if content_type == "tasks" then
										return nil, list.tasks
									elseif current_task then
										for task_index, task in ipairs(list.tasks) do
											if task.title and task.title == current_task then
												if content_type == "task" then
													return task_index, task
												else
													-- print("Invalid type for task level")
													return nil, nil
												end
											end
										end
									else
										-- print("Invalid type for list level")
										return nil, nil
									end
								else
									return nil, nil
								end
							end
						end
					else
						-- print("Invalid type for board level")
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

function M.get_data(content_type)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, item = find_data(content_type, boards)
	if item then
		return item
	end
end

local function update(content_type, input)
	if not input or input == "" then
		return nil
	end

	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, item = find_data(content_type, boards)
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

function M.add_data(content_type, input)
	if not input or input == "" then
		return nil
	end

	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, item = find_data(content_type, boards)
	if not item then
		return nil
	end
	table.insert(item, M[content_type].default_value(input))

	local success = rewind.util.save_json_file(rewind.config.options.file_path, boards)
	if not success then
		return nil
	end
	return true
end

function M.delete_data(content_type)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if not boards then
		return nil
	end

	local _, parent = find_data(content_type .. "s", boards)
	if not parent then
		return nil
	end

	local index, item = find_data(content_type, boards)
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

function M.get(content_type)
	local content = M.get_data(content_type)
	if content then
		local formated_content = rewind.formatting.setup(content_type, content)
		if formated_content and #formated_content > 0 then
			rewind.state.set_current(content_type, formated_content)
		else
			rewind.state.set_current(content_type, {})
		end
	else
		rewind.state.set_current(content_type, {})
	end
end

function M.get_first(content_type)
	local content = rewind.controller.get_data(content_type)
	if content and #content > 0 then
		local first_list = content[1].title
		if first_list then
			return first_list
		end
	end
end

function M.set(content_type, input)
	print(content_type or "" .. input or "")
	if update(content_type, input) then
		rewind.util.update_content(content_type .. "s")
	end
end

function M.add(content_type, input)
	if rewind.controller.add_data(input, content_type) then
		rewind.util.update_content(content_type)
	end
end

function M.delete(content_type)
	if rewind.controller.delete_data(content_type) then
		rewind.util.update_content(content_type .. "s")
	end
end

return M
