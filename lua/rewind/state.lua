local M = {
	buf = {},
	win = {},
}

function M.reset_buffers()
	for _, buf in pairs(M.buf) do
		if api.nvim_buf_is_valid(buf) then
			api.nvim_buf_delete(buf, { force = true })
		end
	end
end

function M.init_buffer(key)
	M.buf[key] = vim.api.nvim_create_buf(false, true)
end

function M.reset_windows()
	for _, win in pairs(M.win) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	M.win = {}
end

return M
