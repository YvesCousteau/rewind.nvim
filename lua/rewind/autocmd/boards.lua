local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.autocmd.win_close(rewind.state.buf.boards, function()
		rewind.ui.close_all_window()
	end)

	rewind.autocmd.cursor_move(rewind.state.buf.boards, function()
		rewind.util.update_highlight(rewind.state.buf.boards, rewind.state.namespace.highlight)
		local current_board = rewind.state.set_current("board", api.nvim_get_current_line())
		local current_list = rewind.state.set_current("list", rewind.controller.lists.get_first(current_board))
		local updated_lists = rewind.controller.lists.get(current_board)
		local updated_tasks = rewind.controller.tasks.get(current_board, current_list)
		rewind.util.update_contents(rewind.state.buf.lists, updated_lists)
		rewind.util.update_contents(rewind.state.buf.tasks, updated_tasks)
	end)
end

return M
