-- Better syntax highlights
return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			multiline_threshold = 5,
		}
	},
	{
		-- Inline annotations for embedded languages. e.g. in strings
		-- Incompatible with the "master" branch of treesitter
		-- "TheNoeTrevino/roids.nvim"
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- XXX: Textobjects plugin is not yet compatible with the main branch
		branch = "main",
		config = function()
			-- local treesitter = require('nvim-treesitter')
			-- treesitter.install { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "go" }
			vim.treesitter.start()
		end

	},
}
