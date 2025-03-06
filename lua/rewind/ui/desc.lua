local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	local _, task = util.get_cursor_content("tasks")
	if not task or not task.desc then
		return nil
	end

	util.win.set(key)

	local buf = util.buf.get(key)
	local win = util.win.get(key)
	if win and buf then
		vim.api.nvim_buf_set_option(buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { task.desc or "" })
		local line_length = #task.desc
		vim.api.nvim_win_set_cursor(win, { 1, line_length })
		vim.cmd("startinsert!")
	end
end

function M.close_window(key, skip)
	vim.cmd("stopinsert")

	if not skip then
		-- local lines = table.concat(util.buf.get_line(key), "\n")
		-- vim.schedule(function()
		-- 	command.update_item("tasks", { key = "desc", data = lines })
		-- end)
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
