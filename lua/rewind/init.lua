local augroup = vim.api.nvim_create_augroup("Rewind", {
	clear = true, -- clears the previous autocommands instead of creating multiple autocommands.
})

local function main()
	print("Hello from our plugin")
end

local function setup()
	vim.api.nvim_create_autocmd(
		"VimEnter",
		{ group = augroup, desc = "Set a fennel scratch buffer on load", once = true, callback = main }
	)
end

return { setup = setup }
