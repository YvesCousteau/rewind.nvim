local M = {}
local rewind = require("rewind")
local util = rewind.util

function M.set(key, events, callback)
	local buf = nil
	if key then
		buf = util.buf.get(key)
	end
	if type(events) == "table" and #events > 0 then
		for _, event in pairs(events) do
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
		end

		if buf then
			vim.api.nvim_create_autocmd(events, {
				buffer = buf,
				callback = callback,
			})
		end
	else
		print("Unable to set a autocmd " .. vim.inspect(events))
	end
end

return M
