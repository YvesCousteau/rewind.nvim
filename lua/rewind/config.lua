local M = {}

M.defaults = {
	file_path = "/path/to/save/todo.json",
	ui = {
		width_percentage = 0.8,
		height_percentage = 0.8,
		border_style = "rounded",
		zindex_base = 50,
	},
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

return M
