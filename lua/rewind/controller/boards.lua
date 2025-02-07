local rewind = require("rewind")
local M = {}

function M.get()
	local content = rewind.controller.get_data("boards")
	local formated_content = rewind.formatting.setup(content, "boards")
	if formated_content and #formated_content > 0 then
		return formated_content
	end
	return {}
end

function M.set(board_title, input)
	if rewind.controller.update_data(input, "board", board_title) then
		rewind.util.update_contents("boards")
	end
end

function M.add(input)
	if rewind.controller.add_data(input, "boards") then
		rewind.util.update_contents("boards")
	end
end

function M.delete(board_title, list_title)
	if rewind.controller.delete_data("board", board_title) then
		rewind.util.update_contents("boards")
	end
end

-- function M.reload()
-- 	rewind.util.update_contents(rewind.state.buf.boards, rewind.state.get_current("board"))
-- end

function M.default_value(title)
	return {
		title = title,
		lists = {},
	}
end

return M
