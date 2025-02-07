local rewind = require("rewind")
local M = {}

function M.get(board_title)
	local lists = rewind.controller.get_data("lists", board_title)
	if lists and #lists > 0 then
		local lists_title = {}
		for _, list in ipairs(lists) do
			table.insert(lists_title, list.title)
		end
		return lists_title
	end
	return {}
end

function M.get_first(board_title)
	local lists = rewind.controller.get_data("lists", board_title)
	if lists and #lists > 0 then
		local first_list = lists[1].title
		if first_list then
			return first_list
		end
	end
end

function M.set(board_title, list_title, input)
	if rewind.controller.update_data(input, "list", board_title, list_title) then
		local updated_data = M.get(board_title)
		rewind.util.update_contents(rewind.state.buf.lists, updated_data)
	end
end

function M.add(board_title, input)
	if rewind.controller.add_data(input, "list", board_title) then
		local updated_data = M.get(board_title)
		rewind.util.update_contents(rewind.state.buf.lists, updated_data)
	end
end

function M.delete(board_title, list_title)
	if rewind.controller.delete_data("list", board_title, list_title) then
		local updated_data = M.get(board_title)
		rewind.util.update_contents(rewind.state.buf.lists, updated_data)
	end
end

return M
