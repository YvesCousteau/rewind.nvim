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

	rewind.autocmd.cursor_move(buf.boards, function()
		print("ldsjf")
		rewind.util.update_highlight(buf.boards, rewind.state.highlight_namespace)
		local current_board = api.nvim_get_current_line()
		rewind.util.update_contents(buf.lists, rewind.controller.lists.get(current_board))
		rewind.util.update_contents(
			buf.tasks,
			rewind.controller.lists.get(current_board, rewind.controller.lists.get_first(current_board))
		)
	end)
end

return M
