local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function M.get_items()
	local items = {}
	local raw_items = {}

	table.insert(items, config.status.todo)
	table.insert(raw_items, "TODO")
	table.insert(items, config.status.doing)
	table.insert(raw_items, "DOING")
	table.insert(items, config.status.done)
	table.insert(raw_items, "DONE")

	return items, raw_items
end

return M
