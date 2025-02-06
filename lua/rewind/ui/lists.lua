local api = vim.api
local rewind = require("rewind")
local M = {}

function M.create_window(buf, win, config)
	local pos = rewind.config.options.ui.position.lists
	rewind.ui.util.create_window(rewind.state.buf, "lists", rewind.state.win.static, pos, false, false)
end

return M
