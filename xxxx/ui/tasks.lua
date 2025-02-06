local api = vim.api
local rewind = require("rewind")
local M = {}

function M.create_window(buf, win, config)
	rewind.ui.util.create_window(
		buf,
		"tasks",
		win,
		" TASKS ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 2.52),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		false,
		false
	)
end

return M
