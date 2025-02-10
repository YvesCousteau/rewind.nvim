local M = {}
local boards = require("rewind.command.boards")
local lists = require("rewind.command.lists")
local tasks = require("rewind.command.tasks")
local help = require("rewind.command.help")
local util = require("rewind.util")

M.commands = {
	boards = boards,
	lists = lists,
	tasks = tasks,
	help_min = help,
	help_max = help,
}

function M.get_items(key)
	local content = {}
	if M.commands[key] ~= nil then
		local items = M.commands[key].get_items()
		if items and #items > 0 then
			content = items
		end
	end
	util.buf.set_buffer(key, content)
end

return M
