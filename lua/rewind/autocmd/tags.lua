local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tags"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)
	end)

	autocmd.util.set(key, { "WinClosed" }, function()
		util.tags.reset_tags_color()
	end)
end

return M
