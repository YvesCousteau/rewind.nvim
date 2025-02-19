local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get_items()
	local titles = {}
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	if data and current_board then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					table.insert(titles, list.title)
				end
				return titles, board.lists
			end
		end
	end
end

return M
