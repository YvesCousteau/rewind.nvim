local M = {
	buf = {},
	win = {
		core = {},
		optinal = {},
	},
}

function M.init_buffers()
	M.buf.boards = vim.api.nvim_create_buf(false, true)
	M.buf.lists = vim.api.nvim_create_buf(false, true)
	M.buf.tasks = vim.api.nvim_create_buf(false, true)
	M.buf.help = vim.api.nvim_create_buf(false, true)
	M.buf.input = vim.api.nvim_create_buf(false, true)
end

function M.reset_windows()
	for _, item in pairs(M.win) do
		for _, win in pairs(M.win[item]) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end
	end
	M.win.static = {}
	M.win.floating = {}
end

return M
