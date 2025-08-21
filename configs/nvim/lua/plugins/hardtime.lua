return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		restriction_mode = "hint",
		disabled_keys = {
			["<Up>"] = {},
			["<Down>"] = {},
			["<Left>"] = {},
			["<Right>"] = {},
		}
	}
}
