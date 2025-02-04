-- In config.lua, add PRIORITIES to the defaults
local M = {}

M.defaults = {
	file_path = vim.fn.stdpath("data") .. "/path/to/save/todo.json",
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
