local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "boards"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)
		command.get_items("lists")
	end)
end

return M
