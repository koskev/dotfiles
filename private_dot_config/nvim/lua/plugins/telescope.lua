return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = { { 'nvim-lua/plenary.nvim' } },
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help" })
		vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Commands" })

		vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = "LSP references" })
		vim.keymap.set('n', '<leader>li', builtin.lsp_references, { desc = "LSP implementations" })

		vim.keymap.set('n', '<leader>ss', builtin.spell_suggest, { dec = "Spelling suggestions" })

		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo tree" })
	end

}
-- Maybe fzf?
-- {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
