local M = {}
local rewind = require("rewind")
local util = rewind.util
M.util = rewind.lazy_load("rewind.autocmd.util")

M.autocmds = {}

local function common(key)
	M.util.set_autocmd(key, { "WinLeave" }, function()
		util.set_prev_buf(key)
	end)
	M.util.set_autocmd(key, { "CursorMoved" }, function()
		-- should update highlight into formating update
	end)
end

function M.setup(key)
	if M.autocmds[key] ~= nil then
		M.autocmds[key].setup()
	end
	common(key)
end

return M
