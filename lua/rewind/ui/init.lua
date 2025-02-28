local M = {}
local rewind = require("rewind")
local state = rewind.state
local util = rewind.util
local autocmd = rewind.autocmd
local keymap = rewind.keymap
M.util = rewind.lazy_load("rewind.ui.util")

local prompt = rewind.lazy_load("rewind.ui.prompt")
local help = rewind.lazy_load("rewind.ui.help")
local confirmation = rewind.lazy_load("rewind.ui.confirmation")
local date_picker = rewind.lazy_load("rewind.ui.date_picker")
local status = rewind.lazy_load("rewind.ui.status")
local tags = rewind.lazy_load("rewind.ui.tags")

M.list = {
	prompt = prompt,
	help_min = M.util,
	help_max = M.util,
	confirmation = confirmation,
	date_picker = date_picker,
	status = status,
	tags = tags,
}

function create_window(key)
	util.buf.init(key)
	util.win.init(key)
end

function M.setup()
	util.buf.reset()
	util.win.reset()

	for _, key in pairs(state.list) do
		create_window(key)
	end
	for _, key in pairs(state.list) do
		autocmd.setup(key)
		keymap.setup(key)
	end
end

return M
