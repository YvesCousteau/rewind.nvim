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

return M
