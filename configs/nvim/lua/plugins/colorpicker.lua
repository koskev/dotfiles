return {
	"uga-rosa/ccc.nvim",
	opts = {
		highlighter = {
			auto_enable = true,
			lsp = true,
		},
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>cp", "<cmd>CccPick<cr>",              desc = "Pick" },
		{ "<leader>cc", "<cmd>CccConvert<cr>",           desc = "Convert" },
		{ "<leader>ch", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
	},
}
