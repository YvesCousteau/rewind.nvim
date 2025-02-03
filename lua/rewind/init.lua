local M = {}

function M.say_hello()
	print("Hello from Neovim!")
end

function M.setup(opts)
	-- Merge user options with defaults
	opts = opts or {}

	vim.api.nvim_create_user_command("Rewind", M.say_hello, {})

	local keymap = opts.keymap or "<leader>hw"

	vim.keymap.set("n", keymap, M.say_hello, {
		desc = "Say hello from our plugin",
		silent = true, -- Prevents the command from being echoed in the command line
	})
end

return M
