local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	util.win.set(key)

	local _, board = util.get_cursor_content("boards")
	local buf = util.buf.get(key)

	command.list.tags.get_tags(function(buf, board, id, tag)
		local name = board.title .. "_tag_" .. tostring(id)
		local ns = vim.api.nvim_create_namespace(name .. "_ns")
		util.set_var(name .. "_ns", ns)
		vim.api.nvim_set_hl(0, name, { fg = tag.color })
		vim.api.nvim_buf_add_highlight(buf, ns, name, id - 1, 0, -1)
	end)
end

function M.close_window(key, skip)
	if not skip then
		local tag = util.get_cursor_content(key)
		if tag then
			command.update_item("tasks", { key = "tags", data = tag })
		end
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
