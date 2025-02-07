local rewind = require("rewind")
local M = {}

function M.get()
	local content = rewind.controller.get_data("lists", rewind.state.get_current("board"))
	local formated_content = rewind.formatting.setup(content, "lists")
	if formated_content and #formated_content > 0 then
		return formated_content
	end
	return {}
end

function M.get_first()
	print(rewind.state.get_current("list"))
	local lists = rewind.controller.get_data("lists", rewind.state.get_current("board"))
	if lists and #lists > 0 then
		local first_list = lists[1].title
		if first_list then
			return first_list
		end
	end
end

function M.set(board_title, list_title, input)
	if rewind.controller.update_data(input, "list", board_title, list_title) then
		rewind.util.update_contents("lists")
	end
end

function M.add(board_title, input)
	if rewind.controller.add_data(input, "lists", board_title) then
		rewind.util.update_contents("lists")
	end
end

function M.delete(board_title, list_title)
	if rewind.controller.delete_data("list", board_title, list_title) then
		rewind.util.update_contents("lists")
	end
end

-- function M.reload()
-- 	rewind.util.update_contents(rewind.state.buf.lists, rewind.state.get_current("list"))
-- end

function M.default_value(title)
	return {
		title = title,
		tasks = {},
	}
end

return M
