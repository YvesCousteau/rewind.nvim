local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.autocmd.win_close(rewind.state.buf.boards, function()
		rewind.ui.close_all_window()
	end)

	rewind.autocmd.cursor_move(rewind.state.buf.boards, function()
		rewind.util.update_highlight(rewind.state.buf.boards, rewind.state.namespace.highlight)
		rewind.state.set_current("board", api.nvim_get_current_line())
		rewind.state.set_current("list", rewind.controller.lists.get_first())
		rewind.state.set_current("lists", rewind.controller.lists.get())
		rewind.state.set_current("tasks", rewind.controller.tasks.get())
		rewind.util.update_contents("lists")
		rewind.util.update_contents("tasks")
	end)
end

return M
