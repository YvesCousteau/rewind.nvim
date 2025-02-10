local M = {}
local config = require("rewind.config")
local util = require("rewind.util")
local keymap = require("rewind.keymap")
local command = require("rewind.command")

function create_window(key)
	util.buf.init_buffer(key)
	util.win.init_window(key)

	keymap.setup(key)
	command.get_items(key)
end

function M.setup()
	util.buf.reset_buffers()
	util.win.reset_windows()

	for key, _ in pairs(config.windows.custom) do
		create_window(key)
	end
end

return M
