local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.autocmd.boards.setup()

	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", true)
	api.nvim_buf_set_lines(rewind.state.buf.boards, 0, -1, false, rewind.controller.boards.get())
	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", false)

	rewind.util.clear_highlights(rewind.state.buf, rewind.state.namespace.highlight)
	rewind.util.update_highlight(rewind.state.buf.boards, rewind.state.namespace.highlight)

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
