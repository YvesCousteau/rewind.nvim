local rewind = require("rewind")
local M = {}

function M.get()
	local boards = rewind.controller.get_data("boards")
	if boards and #boards > 0 then
		local boards_title = {}
		for _, board in ipairs(boards) do
			if board.title then
				table.insert(boards_title, board.title)
			end
		end
		return boards_title
	end
	return {}
end

function M.set(board_title, input)
	rewind.controller.update_data(input, "tasks", board_title)
end

return M
