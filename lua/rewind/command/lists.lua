local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get_items()
	local titles = {}
	local boards = data.load_items()
	local current_board = util.get_cursor_content("boards")
	if boards and current_board then
		for _, board in ipairs(boards) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					table.insert(titles, list.title)
				end
				return titles, board.lists
			end
		end
	end
end

function M.add_item(title)
	local boards = data.load_items()
	local new_item = {
		title = title,
		tasks = {},
	}
	local current_board = util.get_cursor_content("boards")
	if boards and current_board then
		for _, board in ipairs(boards) do
			if board.title == current_board.title then
				table.insert(board.lists, new_item)
				return data.update_items(boards)
			end
		end
	end
end

function M.delete_item()
	local boards = data.load_items()
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	if boards and current_board and current_list then
		for _, board in ipairs(boards) do
			if board.title == current_board.title then
				for id, list in ipairs(board.lists) do
					if list.title == current_list.title then
						table.remove(board.lists, id)
						return data.update_items(boards)
					end
				end
			end
		end
	end
end

function M.update_item(title)
	local boards = data.load_items()
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	if boards and current_board and current_list then
		for _, board in ipairs(boards) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					if list.title == current_list.title then
						list.title = title
						return data.update_items(boards)
					end
				end
			end
		end
	end
end

return M
