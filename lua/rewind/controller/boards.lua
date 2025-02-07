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
	if rewind.controller.update_data(input, "board", board_title) then
		local current_boards = rewind.state.set_current("boards", M.get())
		rewind.util.update_contents(rewind.state.buf.boards, current_boards)
	end
end

function M.add(input)
	if rewind.controller.add_data(input, "boards") then
		local current_boards = rewind.state.set_current("boards", M.get())
		rewind.util.update_contents(rewind.state.buf.boards, current_boards)
	end
end

function M.delete(board_title, list_title)
	if rewind.controller.delete_data("board", board_title) then
		local current_boards = rewind.state.set_current("boards", M.get())
		rewind.util.update_contents(rewind.state.buf.boards, current_boards)
	end
end

function M.default_value(title)
	return {
		title = title,
		lists = {},
	}
end

return M
