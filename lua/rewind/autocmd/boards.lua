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
		rewind.state.set_current("list", rewind.controller.get_first("lists"))
		rewind.util.update_content("lists")
		rewind.util.update_content("tasks")
	end)
end

return M
