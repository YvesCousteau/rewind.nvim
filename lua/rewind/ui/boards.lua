local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.autocmd.boards.setup()
	rewind.keymaps.boards.setup()
	rewind.controller.get("boards")

	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", true)
	api.nvim_buf_set_lines(rewind.state.buf.boards, 0, -1, false, rewind.state.get_current("boards"))
	api.nvim_buf_set_option(rewind.state.buf.boards, "modifiable", false)

	rewind.util.clear_highlights(rewind.state.buf, rewind.state.namespace.highlight)
	rewind.util.update_highlight(rewind.state.buf.boards, rewind.state.namespace.highlight)
end

function M.create_window()
	local pos = rewind.config.options.ui.position.boards
	rewind.ui.create_window(rewind.state.buf, "boards", rewind.state.win.static, pos, true, true)
end

return M
