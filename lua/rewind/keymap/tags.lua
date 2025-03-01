local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tags"
	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.list.status.close_window(key, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.select }, function()
		ui.util.toggle_window(key)
	end)

	keymap.util.set(key, "n", { config.keymaps.add }, function()
		util.prompt.set(key, function(prompt)
			command.add_item(key, prompt)
		end, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.delete }, function()
		util.confirmation.set(key, function()
			-- command.delete_item(key)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.update }, function()
		util.prompt.set(key, function(prompt)
			-- command.update_item(key, { key = "", data = prompt })
		end)
	end)
end

return M
