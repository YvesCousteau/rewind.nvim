local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get_items()
	local titles = {}
	local boards = data.load_items()
	if boards then
		for _, board in ipairs(boards) do
			table.insert(titles, board.title)
		end
	end
	return titles, boards
end

function M.add_item(title)
	local boards = data.load_items()
	local new_item = {
		title = title,
		lists = {},
	}
	if boards then
		table.insert(boards, new_item)
		return data.update_items(boards)
	end
end

function M.delete_item()
	local boards = data.load_items()
	local current_board = util.get_cursor_content("boards")
	if boards and current_board then
		for id, board in ipairs(boards) do
			if board.title == current_board.title then
				table.remove(boards, id)
				return data.update_items(boards)
			end
		end
	end
end

function M.update_item(title)
	local boards = data.load_items()
	local current_board = util.get_cursor_content("boards")
	if boards and current_board then
		for _, board in ipairs(boards) do
			if board.title == current_board.title then
				board.title = title
				return data.update_items(boards)
			end
		end
	end
end

return M
