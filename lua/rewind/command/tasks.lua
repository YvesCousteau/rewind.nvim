local task_manager = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util
local command = rewind.command

-- Retrieves the index and task object based on the current task title.
function task_manager.find_task(list, current_task)
	if list then
		for index, task in ipairs(list.tasks) do
			if current_task and task.title == current_task.title then
				return index, task
			end
		end
	end
	return nil, nil
end

-- Retrieves a single task by its title from the current list.
function task_manager.get_task_by_title(title)
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				for _, task in ipairs(list.tasks) do
					if task.title == title then
						return task
					end
				end
			end
		end
	end

	print("Task with title '" .. title .. "' not found.")
	return nil
end

-- Retrieves all task details for the current list.
function task_manager.get_task_details()
	local task_details = {}
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				task_manager.get(list, nil, function(title, state, date, tags, id, desc)
					local name = "  [" .. state .. "] - " .. title .. " "
					local tag_text = ""
					for _, tag in ipairs(tags) do
						tag_text = tag_text .. "󰽢 "
					end
					if tag_text ~= "" then
						name = name .. "󰌕 " .. tag_text
					end

					if date ~= "UNDEFINED" then
						name = name .. "󰸗 " .. date
					else
						name = name .. "󰃴"
					end
					if desc ~= "" then
						name = name .. " - desc"
					else
						name = name .. " - no desc"
					end
					table.insert(task_details, name)
				end)
				return task_details, list.tasks
			end
		end
	end
	return task_details, {}
end

-- Adds a new task with the given title to the current list.
function task_manager.add_task(title)
	if not title or title == "" then
		print("Title cannot be empty")
		return false
	end

	local new_task = {
		title = title,
		state = "TODO",
		date = "UNDEFINED",
		tags = {},
		desc = "",
	}

	local boards = data.load_items()
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				for _, task in ipairs(list.tasks) do
					if task.title == title then
						print("Task with title '" .. title .. "' already exists.")
						return false
					end
				end
				table.insert(list.tasks, new_task)
				return data.update_items(boards)
			end
		end
	end

	print("Board or list not found.")
	return false
end

-- Deletes the current task from the current list.
function task_manager.delete_current_task()
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")
	local current_task = util.get_var("current_task")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and current_task then
				local index, _ = task_manager.find_task(list, current_task)
				if list.tasks and index then
					table.remove(list.tasks, index)
					return data.update_items(boards)
				end
			end
		end
	end

	print("Task, list, or board not found.")
	return false
end

-- Updates the current task with the provided key-value pair.
function task_manager.update_current_task(key, value)
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")
	local current_task = util.get_var("current_task")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and current_task then
				local _, task = task_manager.find_task(list, current_task)
				if task and task[key] ~= nil then
					task[key] = value
					return data.update_items(boards)
				end
			end
		end
	end

	print("Task or key not found.")
	return false
end

return task_manager
