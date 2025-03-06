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

	autocmd.util.set(nil, { "BufWrite_" .. key }, function()
		print("shlsjfjdls")
		util.tasks.init_tags_color()
	end, "tasks")

	-- autocmd.util.set(key, { "BufWrite", "BufWritePost" }, function()
	-- 	print("shlsjfjdls")
	-- 	util.tasks.init_tags_color()
	-- end)
end

return M
