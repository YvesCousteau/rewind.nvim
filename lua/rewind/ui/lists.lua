local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	api.nvim_buf_set_option(rewind.state.buf.lists, "modifiable", true)

	rewind.autocmd.cursor_move(rewind.state.buf.lists, function()
		rewind.util.update_highlight(rewind.state.buf.lists, rewind.state.highlight_namespace)
		local current_board = rewind.state.current.board
		local current_list = rewind.state.set_current("list", api.nvim_get_current_line())
		local updated_tasks = rewind.controller.tasks.get(current_board, current_list)
		rewind.util.update_contents(rewind.state.buf.tasks, updated_tasks)
	end)

	api.nvim_buf_set_option(rewind.state.buf.lists, "modifiable", false)

	rewind.util.clear_highlights(rewind.state.buf, rewind.state.highlight_namespace)
	rewind.util.update_highlight(rewind.state.buf.lists, rewind.state.highlight_namespace)

	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.select, function()
		local current_board = rewind.state.current.board
		if not rewind.util.is_buffer_empty(rewind.state.buf.tasks) then
			api.nvim_set_current_win(rewind.state.win.static.tasks)
		end
	end)

	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.back, function()
		api.nvim_set_current_win(rewind.state.win.static.boards)
	end)
end

function M.create_window(buf, win, config)
	local pos = rewind.config.options.ui.position.lists
	rewind.ui.util.create_window(rewind.state.buf, "lists", rewind.state.win.static, pos, false, false)
end

return M
