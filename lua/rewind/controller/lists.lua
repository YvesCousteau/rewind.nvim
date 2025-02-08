local rewind = require("rewind")
local M = {}

function M.add(board_title, input)
	if rewind.controller.add_data(input, "lists", board_title) then
		rewind.util.update_content("lists")
	end
end

function M.delete(board_title, list_title)
	if rewind.controller.delete_data("list", board_title, list_title) then
		rewind.util.update_content("lists")
	end
end

-- function M.reload()
-- 	rewind.util.update_content(rewind.state.buf.lists, rewind.state.get_current("list"))
-- end

function M.default_value(title)
	return {
		title = title,
		tasks = {},
	}
end

return M
