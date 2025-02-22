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

	local default_prompt = util.get_cursor_content(prompt.key).title
	if not default_prompt then
		default_prompt = ""
	end
	print("lsdkf: " .. default_prompt)

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

	local prompt_value = util.buf.get_line(key, 1)
	vim.schedule(function()
		-- print(prompt_value)
		if prompt_value then
			prompt.callback(prompt_value)
		end
	end)

	local buf = util.buf.get(prompt.key)
	if buf then
		util.switch_window(buf)
	end
	util.win.close(key)
end

return M
