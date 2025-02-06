-- In config.lua, add PRIORITIES to the defaults
local M = {}

M.defaults = {
	file_path = vim.fn.stdpath("data") .. "/path/to/save/todo.json",
	ui = {
		width_percentage = 0.8,
		height_percentage = 0.8,
		position = {
			boards = {
				title = " 󱁳 BOARDS ",
				width_mult = 0.25,
				height_mult = 0.5,
				col_mult = 0.24,
				row_mult = 0.35,
				layout = "center",
			},
			lists = {
				title = " 󰉺 LISTS ",
				width_mult = 0.25,
				height_mult = 0.5,
				col_mult = 0.5,
				row_mult = 0.35,
				layout = "center",
			},
			tasks = {
				title = " 󰸞 TASKS ",
				width_mult = 0.25,
				height_mult = 0.5,
				col_mult = 0.76,
				row_mult = 0.35,
				layout = "center",
			},
			help = {
				title = " 󰋖 HELP ",
				width_mult = 0.25,
				height_mult = 0.5,
				col_mult = 3.58,
				row_mult = 0.35,
				layout = "center",
			},
			input = {
				title = "  INPUT ",
				width_mult = 0.25,
				height_mult = 0.5,
				col_mult = 0.5,
				row_mult = 0.5,
				layout = "left",
			},
		},
	},
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
