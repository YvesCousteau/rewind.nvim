local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	rewind.autocmd.win_close(rewind.state.buf.help, function()
		rewind.state.help.is_expanded = not rewind.state.help.is_expanded
		rewind.ui.help.open_window()
	end)
end

return M
