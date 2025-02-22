local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get_items()
	local titles = {}
	local data = data.load_items()
	if data then
		for _, board in ipairs(data) do
			table.insert(titles, board.title)
		end
	end
	return titles, data
end

function M.add_item(title)
	local data = data.load_items()
	local new_item = {
		title = title,
		lists = {},
	}
	table.insert(data, new_item)
	return data.update_items(data)
end

function M.delete_item(title)
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	if data and current_board then
		for id, board in ipairs(data) do
			if board.title == current_board.title then
				table.remove(data, id)
				return data.update_items(data)
			end
		end
	end
end

function M.update_item(title)
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	if data and current_board then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				board.title = title
				return data.update_items(data)
			end
		end
	end
end

return M
