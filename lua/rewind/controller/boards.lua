local rewind = require("rewind")
local M = {}

function M.add(input)
	if rewind.controller.add_data(input, "boards") then
		rewind.util.update_content("boards")
	end
end

function M.delete(board_title, list_title)
	if rewind.controller.delete_data("board", board_title) then
		rewind.util.update_content("boards")
	end
end

-- function M.reload()
-- 	rewind.util.update_content(rewind.state.buf.boards, rewind.state.get_current("board"))
-- end

function M.default_value(title)
	return {
		title = title,
		lists = {},
	}
end

return M
