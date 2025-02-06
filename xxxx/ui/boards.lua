local api = vim.api
local rewind = require("rewind")
local M = {}

function M.create_window(buf, win, config)
	rewind.ui.util.create_window(
		buf,
		"boards",
		win,
		" 󱁳 BOARDS ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 0.44),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		true,
		true
	)

	api.nvim_buf_set_lines(buf.boards, 0, -1, false, rewind.util.get_boards())
	api.nvim_buf_set_option(buf.boards, "modifiable", false)
end

return M
