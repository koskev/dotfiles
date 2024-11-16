return {
	-- My plugins here
	{'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	"mbbill/undotree",
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
				'williamboman/mason.nvim',
				build = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	},
	-- Might want to use mrcjkb/rustaceanvim in the future

	'vim-autoformat/vim-autoformat',
	-- Adjust indent based on used
	'tpope/vim-sleuth',
	-- Show git changes
	'airblade/vim-gitgutter',

	'redhat-developer/yaml-language-server',
	-- For easy inlay hints (uses the native ones)
	'MysticalDevil/inlay-hints.nvim',

	-- Kubernetes completion
	{
		-- "someone-stole-my-name/yaml-companion.nvim",
		-- Fix until merged in main
		"agorgl/yaml-companion.nvim",
		branch = "patch-1",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
		end,
	},
	"b0o/schemastore.nvim",

	-- Helm yaml
	'towolf/vim-helm',

	-- Show error messages fully
	'folke/trouble.nvim',

}
