local M = {}
local rewind = require("rewind")
local util = rewind.util

function M.set(key, events, callback, pattern)
	local buf = nil
	if key then
		buf = util.buf.get(key)
	end
	if type(events) == "table" and #events > 0 then
		for _, event in pairs(events) do
			if buf then
				vim.api.nvim_clear_autocmds({
					event = event,
					buffer = buf,
				})
			end
			if pattern then
				vim.api.nvim_clear_autocmds({
					event = event,
					pattern = pattern,
				})
			end
		end

		if buf then
			vim.api.nvim_create_autocmd(events, {
				buffer = buf,
				callback = callback,
			})
		end
		if pattern then
			vim.api.nvim_create_autocmd(events, {
				pattern = pattern,
				callback = callback,
			})
		end
	else
		print("Unable to set a autocmd " .. vim.inspect(events))
	end
end

return M
