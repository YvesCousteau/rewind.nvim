local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util

function M.get_items()
	local items = {}
	local date = util.date_picker.get()
	if date then
		table.insert(items, tostring(date.year))
		table.insert(items, tostring(date.month))
		table.insert(items, tostring(date.day))
	end
	return items, {}
end

return M
