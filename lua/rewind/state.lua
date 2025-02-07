local api = vim.api
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

function M.set_current(type, value)
	M.current[type] = value
	return M.current[type]
end

return M
