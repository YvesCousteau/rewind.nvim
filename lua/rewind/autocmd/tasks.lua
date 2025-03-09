local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tasks"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)
	end)
end

return M
