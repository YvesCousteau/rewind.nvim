local api = vim.api

local rewind = require("rewind")

local M = {}

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function set_keymap(buf, mode, key, callback, opts)
	opts = vim.tbl_extend("force", {
		noremap = true,
		silent = true,
		callback = callback,
	}, opts or {})
	api.nvim_buf_set_keymap(buf, mode, key, "", opts)
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.quit(win, buf)
	if buf and api.nvim_buf_is_valid(buf) then
		api.nvim_buf_set_keymap(buf, "n", "q", "", {
			callback = function()
				rewind.ui.close_window(win)
			end,
			noremap = true,
			silent = true,
		})
	end
end

function M.help(buf)
	if buf and api.nvim_buf_is_valid(buf) then
		api.nvim_buf_set_keymap(buf, "n", "h", "", {
			callback = function()
				rewind.ui.toggle_help_window()
			end,
			noremap = true,
			silent = true,
		})
	end
end

function M.enter_neutral(buf, callback)
	set_keymap(buf, "n", "<CR>", callback)
end

function M.escape_neutral(buf, callback)
	set_keymap(buf, "n", "<Esc>", callback)
end

function M.delete_neutral(buf, callback)
	set_keymap(buf, "n", "d", callback)
end

function M.add_neutral(buf, callback)
	set_keymap(buf, "n", "a", callback)
end

function M.enter_insert(buf, callback)
	set_keymap(buf, "i", "<CR>", callback)
end

function M.escape_insert(buf, callback)
	set_keymap(buf, "i", "<Esc>", callback)
end

return M
