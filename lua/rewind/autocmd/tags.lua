local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tags"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)
		util.tags.init_tags_color()
	end)
end

return M
