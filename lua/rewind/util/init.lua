local M = {}
local rewind = require("rewind")
local state = rewind.state
local config = rewind.config
M.buf = rewind.lazy_load("rewind.util.buffers")
M.win = rewind.lazy_load("rewind.util.windows")

function M.reset_namespace()
	for _, buf in pairs(state.buf) do
		vim.api.nvim_buf_clear_namespace(buf, state.namespace, 0, -1)
	end
end

function M.set_highlight(buf)
	M.reset_namespace()
	local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
	api.nvim_buf_add_highlight(buf, state.namespace, "", current_line, 0, -1)
end

function M.get_focused_line()
	return vim.api.nvim_get_current_line()
end

function M.toggle_visiblity(key)
	if config.windows.custom[key].is_visible == "false" then
		config.windows.custom[key].is_visible = "true"
	else
		config.windows.custom[key].is_visible = "false"
	end
	return config.windows.custom[key].is_visible
end

return M
