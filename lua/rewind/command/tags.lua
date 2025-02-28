local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function M.get_items()
	local items = {}
	local raw_items = {}
	return items, raw_items
end

function M.update_item(value)
	util.tags.set(value)
end

return M
