local M = {}
local rewind = require("rewind")
local util = rewind.util
M.util = rewind.lazy_load("rewind.autocmd.util")

M.list = {}

local function common(key)
	M.util.set(key, { "WinLeave" }, function()
		util.set_prev_buf(key)
	end)
	M.util.set(key, { "CursorMoved" }, function()
		-- should update highlight into formating update
	end)
end

function M.setup(key)
	if M.list[key] ~= nil then
		M.list[key].setup()
	end
	common(key)
end

return M
