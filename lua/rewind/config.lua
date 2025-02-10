local M = {}

M.defaults = {
	file_path = "/path/to/save/todo.json",
}

M.windows = {
	title = " TITLE ",
	width_percentage = 0.8,
	height_percentage = 0.8,
	width_mult = 0.25,
	height_mult = 0.5,
	layout = "center",
	border = "rounded",
	zindex = 50,
	is_visible = "true",
	is_focused = "false",
	custom = {
		boards = {
			title = " 󱁳 BOARDS ",
			col_mult = 0.24,
			row_mult = 0.35,
			is_focused = "true",
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
			zindex = 200,
			is_visible = "false",
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
			is_visible = "false",
		},
	},
}

M.keymaps = {
	quit = "q",
	back = "<Esc>",
	select = "<CR>",
	help = "h",
	add = "a",
	delete = "d",
	update = "u",
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
