local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function M.get_items()
	local items = {}
	local raw_items = {}
	local date = util.buf.get_var("date_picker")

	if date then
		table.insert(items, config.date_picker.year .. " : " .. tostring(date[1]))
		table.insert(raw_items, date[1])
		table.insert(items, config.date_picker.month .. " : " .. config.month[date[2]])
		table.insert(raw_items, date[2])
		table.insert(items, config.date_picker.day .. " : " .. tostring(date[3]))
		table.insert(raw_items, date[3])
	end
	return items, raw_items
end

function M.update_item(value)
	util.buf.set_var("date_picker", value)
end

return M
