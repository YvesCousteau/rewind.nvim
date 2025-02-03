local M = {}

function M.setup(opts)
	vim.api.nvim_create_user_command("Rewind", function(opts) end, {
		desc = "Todo",
	})
end

return M
