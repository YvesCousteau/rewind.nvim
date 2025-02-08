local api = vim.api
local rewind = require("rewind")
local M = {}

M.buf = {
	boards = nil,
	lists = nil,
	tasks = nil,
	help = nil,
	input = nil,
}

M.win = {
	static = {
		boards = nil,
		lists = nil,
		tasks = nil,
	},
	floating = {
		help = nil,
		input = nil,
	},
}

M.namespace = {
	highlight = api.nvim_create_namespace("HighlightNamespace"),
}

M.current = {
	board = nil,
	boards = nil,
	list = nil,
	lists = nil,
	task = nil,
	tasks = nil,
}

M.help = {
	is_expanded = false,
	type = nil,
}

function M.get_current(content_type)
	return M.current[content_type]
end

function M.set_current(content_type, content)
	local unformated_content = rewind.formatting.reverse(content_type, content)
	if unformated_content then
		M.current[content_type] = unformated_content
	else
		M.current[content_type] = content
	end
	return M.current[content_type]
end

return M
