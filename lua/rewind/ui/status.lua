local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	util.win.set(key)
end

function M.close_window(key)
	util.switch_window("tasks")
	util.win.close(key)
end

return M
