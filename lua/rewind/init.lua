local api = vim.api

local ui = require("rewind.ui")

local M = {}

function M.setup()
	api.nvim_create_user_command("Rewind", ui.toggle_ui, {})
end

return M
