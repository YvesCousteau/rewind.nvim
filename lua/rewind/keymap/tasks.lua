local api = vim.api
local rewind = require("rewind")
local M = {}

function setup()
	rewind.util.set_keymap(rewind.state.buf.tasks, "n", rewind.config.options.keymaps.select, function()
		local current_board = rewind.state.current.board
		local current_list = rewind.state.current.list
		local current_task = api.nvim_get_current_line()
		rewind.ui.input.open_window("|> Update Task ", function(input)
			rewind.controller.tasks.set(current_board, current_list, current_task, input)
		end, current_task)
	end)

	rewind.util.set_keymap(rewind.state.buf.tasks, "n", rewind.config.options.keymaps.back, function()
		api.nvim_set_current_win(rewind.state.win.static.lists)
	end)
end

return M
