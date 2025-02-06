local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", true)

	rewind.autocmd.cursor_move(rewind.state.buf.boards, function()
		rewind.util.update_highlight(rewind.state.buf.boards, rewind.state.highlight_namespace)
		local current_board = rewind.state.set_current("board", api.nvim_get_current_line())
		local current_list = rewind.state.set_current("list", rewind.controller.lists.get_first(current_board))
		local updated_lists = rewind.controller.lists.get(current_board)
		local updated_tasks = rewind.controller.tasks.get(current_board, current_list)
		rewind.util.update_contents(rewind.state.buf.lists, updated_lists)
		rewind.util.update_contents(rewind.state.buf.tasks, updated_tasks)
	end)

	api.nvim_buf_set_lines(rewind.state.buf.boards, 0, -1, false, rewind.controller.boards.get())
	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", false)

	rewind.util.clear_highlights(rewind.state.buf, rewind.state.highlight_namespace)
	rewind.util.update_highlight(rewind.state.buf.boards, rewind.state.highlight_namespace)

	rewind.util.set_keymap(rewind.state.buf.boards, "n", rewind.config.options.keymaps.select, function()
		local current_board = rewind.state.current.board
		if not rewind.util.is_buffer_empty(rewind.state.buf.lists) then
			api.nvim_set_current_win(rewind.state.win.static.lists)
		end
	end)

	rewind.util.set_keymap(rewind.state.buf.boards, "n", rewind.config.options.keymaps.back, function()
		rewind.ui.close_window(rewind.state.win.static.boards)
	end)
end

function M.create_window()
	local pos = rewind.config.options.ui.position.boards
	rewind.ui.util.create_window(rewind.state.buf, "boards", rewind.state.win.static, pos, true, true)
end

return M
