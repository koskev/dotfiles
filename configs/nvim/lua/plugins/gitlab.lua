return {
	"harrisoncramer/gitlab.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-tree/nvim-web-devicons",                        -- Recommended but not required. Icons in discussion tree.
	},
	build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
	config = function()
		require("gitlab").setup()
	end,
}
