local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.util.set_keymap(rewind.state.buf.boards, "n", rewind.config.options.keymaps.select, function()
		local current_board = rewind.state.current.board
		if not rewind.util.is_buffer_empty(rewind.state.buf.lists) then
			api.nvim_set_current_win(rewind.state.win.static.lists)
		end
	end)

	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.add, function()
		rewind.ui.input.open_window("|> Add Board ", function(input)
			rewind.controller.lists.add(input)
		end)
	end)

	rewind.util.set_keymap(rewind.state.buf.boards, "n", rewind.config.options.keymaps.delete, function()
		local current_board = api.nvim_get_current_line()
		rewind.controller.boards.delete(current_board)
	end)

	rewind.util.set_keymap(rewind.state.buf.boards, "n", rewind.config.options.keymaps.back, function()
		rewind.ui.close_window(rewind.state.win.static.boards)
	end)
end

return M
