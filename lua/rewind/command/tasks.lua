local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get_items()
	local titles = {}
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	if data and current_board and current_list then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					if list.title == current_list.title then
						for _, task in ipairs(list.tasks) do
							table.insert(titles, "  [" .. task.state .. "] - " .. task.title)
						end
						return titles, list.tasks
					end
				end
			end
		end
	end
end

return M
