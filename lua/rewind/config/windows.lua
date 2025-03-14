local M = {
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
			title = " 󰪸 BOARDS ",
			col_mult = 0.245,
			row_mult = 0.35,
			is_focused = "true",
		},
		lists = {
			title = " 󰱑 LISTS ",
			col_mult = 0.5,
			row_mult = 0.35,
		},
		tasks = {
			title = " 󰱒 TASKS ",
			col_mult = 0.76,
			row_mult = 0.35,
		},
		prompt = {
			title = " |> PROMPT ",
			height_mult = 0.03,
			col_mult = 0.245,
			row_mult = 0.9,
			layout = "left",
			is_focused = "true",
			is_visible = "false",
		},
		help_min = {
			title = " 󰋖 ",
			height_mult = 0.03,
			col_mult = 0.245,
			row_mult = 0.295,
		},
		help_max = {
			title = " 󰋖 - Expanded ",
			width_mult = 0.4,
			height_mult = 0.35,
			col_mult = 0.43,
			row_mult = 0.43,
			zindex = 100,
			is_visible = "false",
			is_focused = "true",
		},
		confirmation = {
			title = " 󰱒 / 󰅘  ",
			width_mult = 0.06,
			height_mult = 0.04,
			col_mult = 0.6,
			row_mult = 0.55,
			zindex = 75,
			is_visible = "false",
			is_focused = "true",
		},
		date_picker = {
			title = " 󰸗 Date Picker  ",
			height_mult = 0.06,
			col_mult = 0.245,
			row_mult = 0.9,
			is_visible = "false",
			is_focused = "true",
		},
		status = {
			title = " Status  ",
			height_mult = 0.06,
			col_mult = 0.245,
			row_mult = 0.9,
			is_visible = "false",
			is_focused = "true",
		},
		tags = {
			title = " 󰌕 Tags ",
			width_mult = 0.18,
			height_mult = 0.4,
			col_mult = 0.535,
			row_mult = 0.4,
			zindex = 75,
			is_visible = "false",
			is_focused = "true",
		},
		desc = {
			title = " Description ",
			width_mult = 0.18,
			height_mult = 0.4,
			col_mult = 0.535,
			row_mult = 0.4,
			zindex = 75,
			is_visible = "false",
			is_focused = "true",
		},
	},
}

return M
