return {
	"debugloop/telescope-undo.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("telescope").load_extension("undo")
		vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
	end,
}
