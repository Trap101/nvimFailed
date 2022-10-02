require("code_runner").setup({
	-- put here the commands by filetype
	filetype = {
		python = "python3 -u ",
		rust = "cargo run",
	},
})
