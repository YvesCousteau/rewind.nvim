local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui
local command = rewind.command

function M.setup()
	local key = "tasks"

	keymap.util.set(key, "n", {
		config.keymaps.select,
		config.keymaps.update,
	}, function()
		util.prompt.set(key, function(prompt)
			command.update_item(key, { key = "title", data = prompt })
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.add }, function()
		util.prompt.set(key, function(prompt)
			command.add_item(key, prompt)
		end, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.delete }, function()
		util.confirmation.set(key, function()
			command.delete_item(key)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.back }, function()
		util.switch_window("lists")
	end)

	keymap.util.set(key, "n", { config.keymaps.date_picker }, function()
		ui.util.toggle_window("date_picker")
	end)

	keymap.util.set(key, "n", { "c" }, function()
		util.date_picker.clear()
	end)

	keymap.util.set(key, "n", { "s" }, function()
		ui.util.toggle_window("status")
	end)
end

return M
