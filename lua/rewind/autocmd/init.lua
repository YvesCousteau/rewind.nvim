local M = {}
local rewind = require("rewind")
local util = rewind.util
M.util = rewind.lazy_load("rewind.autocmd.util")
local boards = rewind.lazy_load("rewind.autocmd.boards")
local lists = rewind.lazy_load("rewind.autocmd.lists")
local tasks = rewind.lazy_load("rewind.autocmd.tasks")
local confirmation = rewind.lazy_load("rewind.autocmd.confirmation")
local status = rewind.lazy_load("rewind.autocmd.status")
local tags = rewind.lazy_load("rewind.autocmd.tags")

M.list = {
	boards = boards,
	lists = lists,
	tasks = tasks,
	confirmation = confirmation,
	status = status,
	tags = tags,
}

local function common(key)
	M.util.set(key, { "WinLeave" }, function()
		util.set_var("prev_buf", key)
	end)
end

function M.setup(key)
	if M.list[key] ~= nil then
		M.list[key].setup()
	end
	common(key)
end

return M
