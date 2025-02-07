local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.select, function()
		local current_board = rewind.state.current.board
		if not rewind.util.is_buffer_empty(rewind.state.buf.tasks) then
			api.nvim_set_current_win(rewind.state.win.static.tasks)
		end
	end)

	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.add, function()
		local current_board = rewind.state.current.board
		rewind.ui.input.open_window("|> Add List ", function(input)
			rewind.controller.lists.add(current_board, input)
		end)
	end)

	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.delete, function()
		local current_board = rewind.state.current.board
		local current_list = api.nvim_get_current_line()
		rewind.controller.lists.delete(current_board, current_list)
	end)

	rewind.util.set_keymap(rewind.state.buf.lists, "n", rewind.config.options.keymaps.back, function()
		api.nvim_set_current_win(rewind.state.win.static.boards)
	end)
end

return M
