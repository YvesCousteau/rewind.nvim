local list_manager = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util
local command = rewind.command

-- Retrieves the index and list object based on the current list title.
function list_manager.find_list(board, current_list)
	if board then
		for index, list in ipairs(board.lists) do
			if current_list and list.title == current_list.title then
				return index, list
			end
		end
	end
	return nil, nil
end

-- Retrieves a single list by its title from the current board.
function list_manager.get_by_title(title)
	local current_board = util.get_var("current_board")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.lists then
			for _, list in ipairs(board.lists) do
				if list.title == title then
					return list
				end
			end
		end
	end

	print("List with title '" .. title .. "' not found.")
	return nil
end

-- Retrieves all list titles for the current board.
function list_manager.get_all()
	local titles = {}
	local current_board = util.get_var("current_board")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.lists then
			for _, list in ipairs(board.lists) do
				table.insert(titles, list.title)
			end
			return titles, board.lists
		end
	end

	return titles, {}
end

-- Adds a new list with the given title to the current board.
function list_manager.add(title)
	if not title or title == "" then
		print("Title cannot be empty")
		return false
	end

	local new_list = {
		title = title,
		tasks = {},
	}

	local current_board = util.get_var("current_board")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.lists then
			for _, list in ipairs(board.lists) do
				if list.title == title then
					print("List with title '" .. title .. "' already exists.")
					return false
				end
			end

			table.insert(board.lists, new_list)
			return data.update_items(boards)
		end
	end

	print("Board not found.")
	return false
end

-- Deletes the current list from the current board.
function list_manager.delete()
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local index, _ = list_manager.find_list(board, current_list)
			if board.lists and index then
				table.remove(board.lists, index)
				return data.update_items(boards)
			end
		end
	end

	print("List or board not found.")
	return false
end

-- Updates the current list with the provided key-value pair.
function list_manager.update(key, value)
	local current_board = util.get_var("current_board")
	local current_list = util.get_var("current_list")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = list_manager.find_list(board, current_list)
			if list and list[key] ~= nil then
				list[key] = value
				return data.update_items(boards)
			end
		end
	end

	print("List or key not found.")
	return false
end

return list_manager
