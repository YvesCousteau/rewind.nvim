local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util

function M.get_items()
	local items = {}
	table.insert(items, config.confirmation.yes)
	table.insert(items, config.confirmation.no)
	return items, {}
end

return M
