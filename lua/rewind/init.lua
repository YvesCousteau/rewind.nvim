local api = vim.api

local M = {}

local function lazy_load(module_name)
	return setmetatable({}, {
		__index = function(_, key)
			return require(module_name)[key]
		end,
	})
end

M.ui = lazy_load("rewind.ui")
M.workflow = lazy_load("rewind.workflow")
M.help = lazy_load("rewind.help")
M.util = lazy_load("rewind.util")
M.keymap = lazy_load("rewind.keymap")

function M.setup()
	api.nvim_create_user_command("Rewind", M.ui.toggle_ui, {})
end

return M
