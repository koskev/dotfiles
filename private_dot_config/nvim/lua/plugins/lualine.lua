-- Cool statusline at the bottom
return {
	'nvim-lualine/lualine.nvim',
	opts = {
		sections = {
			lualine_c = {
				{
					'filename',
					path = 1,
				}

			}
		}
	}
}
