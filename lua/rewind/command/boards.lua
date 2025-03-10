local board_manager = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

-- Retrieves the index and board object based on the current board title.
function board_manager.find_board(boards, current_board)
	if boards then
		for index, board in ipairs(boards) do
			if current_board and board.title == current_board.title then
				return index, board
			end
		end
	end
	return nil, nil
end

-- Retrieves a single board by its title.
function board_manager.get_board_by_title(title)
	local boards = data.load_items()
	if boards then
		for _, board in ipairs(boards) do
			if board.title == title then
				return board
			end
		end
	end
	print("Board with title '" .. title .. "' not found.")
	return nil
end

-- Retrieves all board titles.
function board_manager.get_board_titles()
	local titles = {}
	local boards = data.load_items()

	if boards then
		for _, board in ipairs(boards) do
			table.insert(titles, board.title)
		end
	end

	return titles, boards or {}
end

-- Adds a new board with the given title.
function board_manager.add_board(title)
	if not title or title == "" then
		print("Title cannot be empty")
		return false
	end

	local new_board = {
		title = title,
		lists = {},
		tags = {},
	}

	local boards = data.load_items()
	if boards then
		for _, board in ipairs(boards) do
			if board.title == title then
				print("Board with title '" .. title .. "' already exists.")
				return false
			end
		end
		table.insert(boards, new_board)
	else
		boards = { new_board }
	end

	return data.update_items(boards)
end

-- Deletes the current board.
function board_manager.delete_current_board()
	local current_board = util.get_var("current_board")
	local boards = data.load_items()

	if boards and current_board then
		local index, _ = board_manager.find_board(boards, current_board)
		if index then
			table.remove(boards, index)
			return data.update_items(boards)
		end
	end

	print("Board not found or no board selected.")
	return false
end

-- Updates the current board with the provided key-value pair.
function board_manager.update_current_board(key, value)
	local current_board = util.get_var("current_board")
	local boards = data.load_items()

	if boards and current_board then
		local _, board = board_manager.find_board(boards, current_board)
		if board and board[key] ~= nil then
			board[key] = value
			return data.update_items(boards)
		end
	end

	print("Board or key not found.")
	return false
end

return board_manager
