local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	api.nvim_create_autocmd("WinClosed", {
		group = rewind.state.win_auto_group,
		callback = function(opts)
			local closed_win_id = tonumber(opts.match)
			if rewind.state.win.static then
				for _, win in pairs(rewind.state.win.static) do
					if closed_win_id == win then
						rewind.ui.close_all_window()
						return
					end
				end
			elseif rewind.state.win.floating then
				if rewind.state.win.floating.help then
					rewind.controller.help.toggle()
				end
			end
		end,
	})

	api.nvim_create_autocmd("WinEnter", {
		group = rewind.state.win_auto_group,
		callback = function()
			-- rewind.ui.help.close_window(current_win)
			local current_win = api.nvim_get_current_win()
			if current_win == rewind.state.win.static.boards then
				rewind.ui.boards.setup()
			elseif current_win == rewind.state.win.static.lists then
				rewind.ui.lists.setup()
			elseif current_win == rewind.state.win.static.tasks then
				rewind.ui.tasks.setup()
			end
		end,
	})
end

function M.cursor_move(buf, callback)
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf,
		callback = callback,
	})
end

return M
