local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui
local command = rewind.command

function M.setup()
	local key = "lists"
	keymap.util.set(key, "n", { config.keymaps.select }, function()
		local _, current_list = util.get_cursor_content("lists")
		if current_list then
			ui.set_var("current_list", current_list)
			ui.util.toggle_window("lists")
			ui.util.toggle_window("tasks")
		end
	end)

	keymap.util.set(key, "n", { config.keymaps.update }, function()
		util.prompt.set(key, "title", function(prompt)
			command.update_item(key, { key = "title", data = prompt })
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.add }, function()
		util.prompt.set(key, nil, function(prompt)
			command.add_item(key, prompt)
		end, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.delete }, function()
		util.confirmation.set(key, function()
			command.delete_item(key)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.set_var("current_list", nil)
		ui.util.toggle_window("boards")
		ui.util.toggle_window("lists")
	end)
end

return M
