local M = {
	buf = {},
	win = {},
	namespace = nil,
}
command = require("rewind.command")

function M.reset_buffers()
	for _, buf in pairs(M.buf) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

function M.init_buffer(key)
	M.buf[key] = vim.api.nvim_create_buf(false, true)
	if not vim.api.nvim_buf_is_valid(M.buf[key]) then
		print("Buffer " .. key .. " is not valid")
	end
end

function M.set_buffer(key)
	local content = command.get_titles(key)
	vim.api.nvim_buf_set_option(M.buf[key], "modifiable", true)
	vim.api.nvim_buf_set_lines(M.buf[key], 0, -1, false, content)
	vim.api.nvim_buf_set_option(M.buf[key], "modifiable", false)
end

function M.reset_windows()
	for _, win in pairs(M.win) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	M.win = {}
end

function M.reset_namespace()
	for _, buf in pairs(M.buf) do
		vim.api.nvim_buf_clear_namespace(buf, M.namespace, 0, -1)
	end
end

function M.set_highlight(buf)
	M.reset_namespace()
	local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
	api.nvim_buf_add_highlight(buf, M.namespace, "", current_line, 0, -1)
end

function M.get_focused_line()
	return vim.api.nvim_get_current_line()
end

function M.get_buffer_line(key)
	local row, col = unpack(vim.api.nvim_buf_get_mark(M.buf[key], '"'))
	local lines = vim.api.nvim_buf_get_lines(M.buf[key], row - 1, row, false)
	if #lines > 0 then
		return lines[1]
	else
		return nil
	end
end

return M
