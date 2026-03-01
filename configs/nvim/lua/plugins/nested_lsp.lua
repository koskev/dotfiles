return {
	'jmbuhr/otter.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	config = function()
		-- TODO: take a look at https://github.com/atusy/kakehashi
		-- TODO: Rust is not working :/
		local otter = require("otter")
		otter.setup({})
		otter.activate()
	end
}
