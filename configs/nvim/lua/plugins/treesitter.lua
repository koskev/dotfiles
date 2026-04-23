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
		"romus204/tree-sitter-manager.nvim",
		dependencies = {}, -- tree-sitter CLI must be installed system-wide
		config = function()
			require("tree-sitter-manager").setup({
				-- Default Options
				ensure_installed = {
					"rust",
					"lua",
					"go",
					"jsonnet",
				}, -- list of parsers to install at the start of a neovim session
				-- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
				-- auto_install = false, -- if enabled, install missing parsers when editing a new file
				-- highlight = true, -- treesitter highlighting is enabled by default
				languages = {
					jsonnet = {
						install_info = {
							url = "https://github.com/koskev/tree-sitter-jsonnet",
							revision = "2d71ee15",
							-- Use the query files that ship with the forked repo instead of
							-- the bundled queries. The parser's queries/ directory is copied
							-- automatically during installation.
							use_repo_queries = false,
						},
					},
				},
				-- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
				-- query_dir = vim.fn.stdpath("data") .. "/site/queries",
			})
		end
	}
}
