-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'wbthomason/packer.nvim',
	-- My plugins here
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = { {'nvim-lua/plenary.nvim'} }
	},
	{'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	},
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
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
	'simrat39/rust-tools.nvim',

	-- use('simrat39/inlay-hints.nvim')
	'vim-autoformat/vim-autoformat',
	-- Adjust indent based on used
	'tpope/vim-sleuth',
	-- Show git changes
	'airblade/vim-gitgutter',
	'ethanholz/nvim-lastplace',

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

})
