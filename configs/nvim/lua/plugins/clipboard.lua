return {
	"AckslD/nvim-neoclip.lua",
	event = "VeryLazy",
	dependencies = {
		{ 'kkharji/sqlite.lua',           module = 'sqlite' },
		{ 'nvim-telescope/telescope.nvim' },
	},
	config = function()
		require('neoclip').setup({
			enable_persistent_history = true,
			history = 100000,
		})
		require('telescope').load_extension('neoclip')
		vim.keymap.set('n', '<leader>fn', ":Telescope neoclip<CR>", { desc = "Find neoclip" })
	end,
}
