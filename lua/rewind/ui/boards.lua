local api = vim.api
local rewind = require("rewind")
local M = {}

function M.create_window()
	local pos = rewind.config.options.ui.position.boards
	rewind.ui.util.create_window(rewind.state.buf, "boards", rewind.state.win.static, pos, true, true)
	api.nvim_buf_set_lines(rewind.state.buf.boards, 0, -1, false, rewind.util.get_boards())
	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", false)
end

return M
