local M = {}
local rewind = require("rewind")
local util = rewind.util
M.util = rewind.lazy_load("rewind.autocmd.util")
local boards = rewind.lazy_load("rewind.autocmd.boards")
local lists = rewind.lazy_load("rewind.autocmd.lists")
local tasks = rewind.lazy_load("rewind.autocmd.tasks")

M.list = {
	boards = boards,
	lists = lists,
	tasks = tasks,
}

local function common(key)
	M.util.set(key, { "WinLeave" }, function()
		util.set_prev_buf(key)
	end)
end

function M.setup(key)
	if M.list[key] ~= nil then
		M.list[key].setup()
	end
	common(key)
end

return M
