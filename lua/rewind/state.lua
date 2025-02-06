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

M.win_auto_group = api.nvim_create_augroup("WindowAugroup", { clear = true })
M.highlight_namespace = api.nvim_create_namespace("HighlightNamespace")

M.current = {
	board = nil,
	list = nil,
	task = nil,
}

function M.set_current(type, value)
	M.current[type] = value
	return M.current[type]
end

return M
