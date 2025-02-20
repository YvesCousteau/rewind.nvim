local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	local prompt = util.get_var("prompt")
	if not prompt or not prompt.key or not prompt.callback then
		return nil
	end

	util.change_window_title(key, "--- [" .. prompt.key .. "] ")
	util.win.set(key)

	local default_prompt = util.buf.get_line(prompt.key) or ""
	local buf = util.buf.get(key)
	local win = util.win.get(key)
	if win and buf then
		vim.api.nvim_buf_set_option(buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default_prompt or "" })
		local line_length = #default_prompt
		vim.api.nvim_win_set_cursor(win, { 1, line_length })
		vim.cmd("startinsert!")
	end
end

function M.close_window(key)
	local prompt = util.get_var("prompt")
	if not prompt or not prompt.key or not prompt.callback then
		return nil
	end
	vim.cmd("stopinsert")
	local current_buf = util.buf.get(key)
	local prompt_value = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)[1]
	vim.schedule(function()
		if prompt_value then
			prompt.callback(prompt_value)
		end
	end)

	local prev_buf = util.buf.get(util.prompt.key)
	util.switch_window(prev_buf)
	util.win.close(key)
end

return M
