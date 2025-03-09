local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	local prompt = util.get_var(key)
	if not prompt or not prompt.key or not prompt.callback or not prompt.prompt then
		return nil
	end

	util.win.set(key)

	local buf = util.buf.get(key)
	local win = util.win.get(key)
	if win and buf then
		vim.api.nvim_buf_set_option(buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prompt.prompt or "" })
		local line_length = #prompt.prompt
		vim.api.nvim_win_set_cursor(win, { 1, line_length })
		vim.cmd("startinsert!")
	end
end

function M.close_window(key, skip)
	local prompt = util.get_var(key)
	if not prompt or not prompt.key or not prompt.callback then
		return nil
	end
	vim.cmd("stopinsert")

	if not skip then
		local prompt_value = util.buf.get_line(key, 1)
		vim.schedule(function()
			if prompt_value and prompt_value ~= "" then
				prompt.callback(prompt_value)
				util.tasks.init_tags_color()
				util.tags.init_tags_color()
			end
		end)
	end

	util.switch_window(prompt.key)
	util.win.close(key)
end

return M
