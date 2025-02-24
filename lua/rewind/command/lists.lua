local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util
local command = rewind.command

function M.get(board, current_list, callback)
	if board then
		for id, list in ipairs(board.lists) do
			if current_list then
				if list.title == current_list.title then
					return id, list
				end
			else
				callback(list.title)
			end
		end
	end
end

function M.get_items()
	local titles = {}
	local _, current_board = util.get_cursor_content("boards")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.lists then
			M.get(board, nil, function(title)
				table.insert(titles, title)
			end)
			return titles, board.lists
		end
	end
	return titles, {}
end

function M.add_item(title)
	local new_item = {
		title = title,
		tasks = {},
	}
	local _, current_board = util.get_cursor_content("boards")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.list then
			table.insert(board.list, new_item)
			return data.update_items(boards)
		end
	end
end

function M.delete_item()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local id, _ = M.get(board, current_list)
			if board.list and id then
				table.remove(board.list, id)
				return data.update_items(boards)
			end
		end
	end
end

function M.update_item(title)
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local _, list = M.get(board, current_list)
			if list and list.title then
				list.title = title
				return data.update_items(boards)
			end
		end
	end
end

return M
