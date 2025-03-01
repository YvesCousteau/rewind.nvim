local M = {}
local rewind = require("rewind")
local state = rewind.state
local config = rewind.config
M.buf = rewind.lazy_load("rewind.util.buffers")
M.win = rewind.lazy_load("rewind.util.windows")
M.prompt = rewind.lazy_load("rewind.util.prompt")
M.confirmation = rewind.lazy_load("rewind.util.confirmation")
M.date_picker = rewind.lazy_load("rewind.util.date_picker")

function M.change_window_title(key, title)
	if title then
		config.windows.custom[key].title_opt = title
	end
end

function M.switch_window(key)
	local win = M.win.get(key)
	if win then
		vim.api.nvim_set_current_win(win)
	end
end

function M.get_var(name)
	return vim.api.nvim_get_var(name)
end

function M.set_var(name, value)
	vim.api.nvim_set_var(name, value)
end

function M.get_cursor_content(key)
	local line_id = M.win.get_cursor_line_id(key)
	local var = M.buf.get_var(key)
	if var and line_id and var[line_id] then
		return line_id, var[line_id]
	end
end

function M.update_highlight(key)
	local buf = M.buf.get(key)
	local line_id = vim.api.nvim_win_get_cursor(0)[1] - 1

	local ns = M.get_var(key .. "ns")
	if buf and line_id and ns then
		vim.api.nvim_set_hl(0, "classic", { link = "Visual" })
		vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		vim.api.nvim_buf_add_highlight(buf, ns, "classic", line_id, 0, -1)
	end
end

return M
