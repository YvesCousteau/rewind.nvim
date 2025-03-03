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
	if boards and current_board then
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
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.lists then
			for _, list in ipairs(board.lists) do
				if list.title == title then
					print("list " .. title .. " is already present")
					return false
				end
			end

			table.insert(board.lists, new_item)
			return data.update_items(boards)
		end
	end
	return false
end

function M.delete_item()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local id, _ = M.get(board, current_list)
			if board.lists and id then
				table.remove(board.lists, id)
				return data.update_items(boards)
			end
		end
	end
end

function M.update_item(value)
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = M.get(board, current_list)
			if list and list[value.key] then
				list[value.key] = value.data
				return data.update_items(boards)
			end
		end
	end
end

return M
