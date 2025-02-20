local M = {
	list = {
		"boards",
		"lists",
		"tasks",
		"prompt",
		"confirmation",
		"date_picker",
		"help_min",
		"help_max",
	},

	namespace = nil,
	prev_buf = nil,
	prompt = {
		key = nil,
		callback = nil,
	},
}

return M
