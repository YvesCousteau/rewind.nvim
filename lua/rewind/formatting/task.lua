local api = vim.api
local rewind = require("rewind")
local M = {}

function M.reverse(content)
	local todo = rewind.config.options.formatting.tasks.state.todo.icon
	local doing = rewind.config.options.formatting.tasks.state.doing.icon
	local done = rewind.config.options.formatting.tasks.state.done.icon
	content = content:gsub("^" .. vim.pesc(todo), "")
	content = content:gsub("^" .. vim.pesc(doing), "")
	content = content:gsub("^" .. vim.pesc(done), "")
	content = content:match("^%s*(.-)%s*$")
	return content
end

return M
