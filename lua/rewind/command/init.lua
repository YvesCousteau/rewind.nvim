local M = {}
local rewind = require("rewind")
local util = rewind.util
local boards = rewind.lazy_load("rewind.command.boards")
local lists = rewind.lazy_load("rewind.command.lists")
local tasks = rewind.lazy_load("rewind.command.tasks")
local help = rewind.lazy_load("rewind.command.help")
local confirmation = rewind.lazy_load("rewind.command.confirmation")

M.list = {
	boards = boards,
	lists = lists,
	tasks = tasks,
	help_min = help,
	help_max = help,
	confirmation = confirmation,
}

function M.get_items(key)
	local content = {}
	local raw_content = {}
	if M.list[key] ~= nil then
		local items, raw_items = M.list[key].get_items()
		if items and #items > 0 then
			content = items
		end
		if raw_items and #raw_items > 0 then
			raw_content = raw_items
		end
	end
	util.buf.set_var(key, raw_content)
	util.buf.set_content(key, content)
end

function M.add_item(key, title)
	local content = {}
	if M.list[key] ~= nil and title then
		local success = M.list[key].add_item(title)
		if success then
			M.get_items(key)
		end
	end
end

function M.update_item(key, title)
	local content = {}
	if M.list[key] ~= nil and title then
		local success = M.list[key].update_item(title)
		if success then
			M.get_items(key)
		end
	end
end

function M.delete_item(key)
	local content = {}
	if M.list[key] ~= nil then
		local success = M.list[key].delete_item()
		if success then
			M.get_items(key)
		end
	end
end

return M
