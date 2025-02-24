local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util
local command = rewind.command

function M.get(list, current_task, callback)
	if list then
		for id, task in ipairs(list.tasks) do
			if current_task then
				if task.title == current_task.title then
					return id, task
				end
			else
				callback(task.title, task.state, task.date)
			end
		end
	end
end

function M.get_items()
	local titles = {}
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				M.get(list, nil, function(title, state, date)
					if date ~= "UNDEFINED" then
						table.insert(titles, "  [" .. state .. "] - " .. title .. " - " .. date)
					else
						table.insert(titles, "  [" .. state .. "] - " .. title)
					end
				end)
				return titles, list.tasks
			end
		end
	end
	return titles, {}
end

function M.add_item(title)
	local new_item = {
		title = title,
		state = "TODO",
		date = "UNDEFINED",
	}

	local boards = data.load_items()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				table.insert(list.tasks, new_item)
				return data.update_items(boards)
			end
		end
	end
end

function M.delete_item()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local _, current_task = util.get_cursor_content("tasks")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local _, list = command.list.lists.get(board, current_list)
			if list then
				local id, _ = M.get(list, current_task)
				if list.tasks and id then
					table.remove(list.tasks, id)
					return data.update_items(boards)
				end
			end
		end
	end
end

function M.update_item(title)
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local _, current_task = util.get_cursor_content("tasks")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local _, list = command.list.lists.get(board, current_list)
			if list then
				local _, task = M.get(list, current_task)
				if task and task.title then
					task.title = title
					return data.update_items(boards)
				end
			end
		end
	end
end

return M
