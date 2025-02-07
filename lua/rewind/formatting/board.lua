local api = vim.api
local rewind = require("rewind")
local M = {}

function M.reverse(content)
	local active_icon = rewind.config.options.formatting.boards.is_active.icon
	local inactive_icon = rewind.config.options.formatting.boards.is_inactive.icon
	content = content:gsub("^" .. vim.pesc(active_icon), "")
	content = content:gsub("^" .. vim.pesc(inactive_icon), "")
	content = content:match("^%s*(.-)%s*$")
	return content
end

return M
