local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.autocmd.win_close(rewind.state.buf.lists, function()
		rewind.ui.close_all_window()
	end)

	rewind.autocmd.cursor_move(rewind.state.buf.lists, function()
		rewind.util.update_highlight(rewind.state.buf.lists, rewind.state.namespace.highlight)
		local current_board = rewind.state.current.board
		local current_list = rewind.state.set_current("list", api.nvim_get_current_line())
		local updated_tasks = rewind.controller.tasks.get(current_board, current_list)
		rewind.util.update_contents(rewind.state.buf.tasks, updated_tasks)
	end)
end

return M
