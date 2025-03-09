local M = {}

function M.lazy_load(module_name)
	return setmetatable({}, {
		__index = function(_, key)
			return require(module_name)[key]
		end,
	})
end

M.state = M.lazy_load("rewind.state")
M.util = M.lazy_load("rewind.util")
M.ui = M.lazy_load("rewind.ui")
M.config = M.lazy_load("rewind.config")
M.keymap = M.lazy_load("rewind.keymap")
M.command = M.lazy_load("rewind.command")
M.data = M.lazy_load("rewind.data")
M.autocmd = M.lazy_load("rewind.autocmd")

function M.setup(opts)
	M.config.setup(opts)
	vim.api.nvim_create_user_command("RewindToggle", M.ui.setup, {})
end

return M
