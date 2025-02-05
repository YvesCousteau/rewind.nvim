local api = vim.api

local rewind = require("rewind")

local M = {}

local state = {
	current_win = nil,
	last_win = nil,
}

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.set_new_state(state_type, new_state)
	if state_type == "win" then
		if state.current_win then
			state.last_win = state.current_win
		end
		state.current_win = new_state
	end
end

function M.get_current_state(state_type)
	if state_type == "win" then
		return state.current_win
	end
end

function M.get_last_state(state_type)
	if state_type == "win" then
		return state.last_win
	end
end

return M
