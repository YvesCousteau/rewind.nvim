local M = {}

M.defaults = {
	file_path = "/path/to/save/todo.json",
	window = {
		default = {
			title = " TITLE ",
			width_percentage = 0.8,
			height_percentage = 0.8,
			width_mult = 0.25,
			height_mult = 0.5,
			layout = "center",
			border_style = "rounded",
			zindex_base = 50,
			visible = true,
			is_focused = false,
		},
		boards = {
			title = " 󱁳 BOARDS ",
			col_mult = 0.24,
			row_mult = 0.35,
			is_focused = true,
		},
		lists = {
			title = " 󰉺 LISTS ",
			col_mult = 0.5,
			row_mult = 0.35,
		},
		tasks = {
			title = " 󰸞 TASKS ",
			col_mult = 0.76,
			row_mult = 0.35,
		},
		input = {
			title = " |> INPUT ",
			width_mult = 0.2,
			height_mult = 0.03,
			col_mult = 0.525,
			row_mult = 0.5,
			layout = "left",
			zindex = 100,
			visible = false,
		},
		help_min = {
			title = " 󰋖 HELP ",
			width_mult = 0.055,
			height_mult = 0.03,
			col_mult = 0.24,
			row_mult = 0.295,
		},
		help_max = {
			title = " 󰋖 HELP - Expanded ",
			width_mult = 0.2,
			height_mult = 0.2,
			col_mult = 0.525,
			row_mult = 0.5,
			zindex = 100,
			visible = false,
		},
	},
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

return M
