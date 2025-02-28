local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util

function M.setup()
	local key = "tags"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)
	end)
end

return M
