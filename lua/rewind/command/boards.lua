local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get(boards, current_board, callback)
	if boards then
		for id, board in ipairs(boards) do
			if current_board then
				if board.title == current_board.title then
					return id, board
				end
			else
				callback(board.title)
			end
		end
	end
end

function M.get_items()
	local titles = {}

	local boards = data.load_items()
	if boards then
		M.get(boards, nil, function(title)
			table.insert(titles, title)
		end)
		return titles, boards
	end
	return titles, {}
end

function M.add_item(title)
	local new_item = {
		title = title,
		lists = {},
	}

	local boards = data.load_items()
	if boards then
		table.insert(boards, new_item)
		return data.update_items(boards)
	end
end

function M.delete_item()
	local _, current_board = util.get_cursor_content("boards")

	local boards = data.load_items()
	if boards then
		local id, _ = M.get(boards, current_board)
		if id then
			table.remove(boards, id)
			return data.update_items(boards)
		end
	end
end

function M.update_item(value)
	local _, current_board = util.get_cursor_content("boards")

	local boards = data.load_items()
	if boards then
		local _, board = M.get(boards, current_board)
		if board and board[value.key] then
			board[value.key] = value.data
			return data.update_items(boards)
		end
	end
end

return M
