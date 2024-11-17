return {
	-- Kubernetes completion
	{
		"someone-stole-my-name/yaml-companion.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
		end,
	},

	-- More JSON schemas
	"b0o/schemastore.nvim",

	-- Helm yaml
	-- Should be covered by helm_ls and treesitter
	-- 'towolf/vim-helm',
}
