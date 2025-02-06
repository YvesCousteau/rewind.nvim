local api = vim.api
local rewind = require("rewind")
local M = {}

function M.create_window(buf, win, config)
	local pos = rewind.config.options.ui.position.tasks
	rewind.ui.util.create_window(rewind.state.buf, "tasks", rewind.state.win.static, pos, false, false)
end

return M
