local M = {}
local config = require("rewind.config")
local ui = require("rewind.ui")

function M.setup(opts)
	config.setup(opts)
	vim.api.nvim_create_user_command("Rewind", ui.setup(), {})
end

return M
