local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
M.util = rewind.lazy_load("rewind.ui.util")

function create_window(key)
	print(key)
	util.buf.init_buffer(key)
	M.util.init_window(key)
end

function M.setup()
	util.buf.reset_buffers()
	util.win.reset_windows()

	for key, _ in pairs(config.windows.custom) do
		create_window(key)
	end
end

return M
