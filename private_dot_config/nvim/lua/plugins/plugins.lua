return {
	-- My plugins here
	"mbbill/undotree",
	-- Might want to use mrcjkb/rustaceanvim in the future

	-- Adjust indent based on used
	'tpope/vim-sleuth',
	-- Show git changes
	'airblade/vim-gitgutter',

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
