local M = {}

function M.setup(opts)
	vim.api.nvim_create_user_command("Rewind", function(input)
		print("Something should happen here...")
	end, {
		{
			bang = true, -- "!" after the cmd is allowed.
			desc = "a new command to do the thing",
		},
	})
end

return M
