local M = {}
local ui = require("rewind.ui")

function M.setup(opts)
	-- Merge user options with defaults
	opts = opts or {}

	vim.api.nvim_create_user_command("Rewind", ui.toggle_ui, {})

	local keymap = opts.keymap or "<leader>hw"

	vim.keymap.set("n", keymap, ui.toggle_ui, {
		desc = "Say hello from our plugin",
		noremap = true,
		silent = true, -- Prevents the command from being echoed in the command line
	})
end

return M
