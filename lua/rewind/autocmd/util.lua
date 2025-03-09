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
			-- Clear autocmds for buffer if they exist
			if buf then
				local success, autocmds = pcall(vim.api.nvim_get_autocmds, {
					event = event,
					buffer = buf,
				})
				if success and #autocmds > 0 then
					vim.api.nvim_clear_autocmds({
						event = event,
						buffer = buf,
					})
				end
			end

			-- Clear autocmds for pattern if they exist
			if pattern then
				local success, autocmds = pcall(vim.api.nvim_get_autocmds, {
					event = event,
					pattern = pattern,
				})
				if success and #autocmds > 0 then
					vim.api.nvim_clear_autocmds({
						event = event,
						pattern = pattern,
					})
				end
			end
		end

		-- Create new autocmds for buffer
		if buf then
			vim.api.nvim_create_autocmd(events, {
				buffer = buf,
				callback = callback,
			})
		end

		-- Create new autocmds for pattern
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
