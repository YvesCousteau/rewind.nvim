local M = {}
local rewind = require("rewind")
local util = rewind.util
local help = rewind.lazy_load("rewind.command.help")

M.list = {
	boards = rewind.lazy_load("rewind.command.boards"),
	lists = rewind.lazy_load("rewind.command.lists"),
	tasks = rewind.lazy_load("rewind.command.tasks"),
	help_min = help,
	help_max = help,
	confirmation = rewind.lazy_load("rewind.command.confirmation"),
	date_picker = rewind.lazy_load("rewind.command.date_picker"),
	status = rewind.lazy_load("rewind.command.status"),
	tags = rewind.lazy_load("rewind.command.tags"),
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

function M.add_item(key, value)
	local content = {}
	if M.list[key] ~= nil and value then
		local success = M.list[key].add_item(value)
		if success then
			M.get_items(key)
		end
	end
end

function M.update_item(key, value)
	local content = {}
	if M.list[key] ~= nil and value then
		local success = M.list[key].update_item(value)
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
