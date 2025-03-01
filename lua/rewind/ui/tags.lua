local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	util.win.set(key)

	local _, board = util.get_cursor_content("boards")
	local buf = util.buf.get(key)

	if buf and board and board.tags and #board.tags > 0 then
		for id, tag in pairs(board.tags) do
			if tag.title then
				-- local ns = util.get_var(board.title .. tag.title .. "ns")
				-- util.set_var(key .. "ns", ns)
				local ns = vim.api.nvim_create_namespace(board.title .. tag.title)

				vim.api.nvim_set_hl(ns, key, { fg = "#FF0000" })
				-- local line = id - 1
				-- local col_start = 0
				-- local col_end = #tag.title
				-- vim.api.nvim_buf_add_highlight(buf, 0, tag.title, line, col_start, col_end)
				vim.api.nvim_buf_add_highlight(buf, ns, key, id - 1, 0, -1)
			end
		end
	end
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
