-- Cool statusline at the bottom
return {
	{
		'linrongbin16/lsp-progress.nvim',
		opts = {
			format = function(client_messages)
				if #client_messages > 0 then
					return table.concat(client_messages, " ")
				end
				return ""
			end
		},
	},
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local lualine = require("lualine")
			lualine.setup({
				sections = {
					lualine_c = {
						{
							'filename',
							path = 1,
						},
						function()
							-- invoke `progress` here.
							return require('lsp-progress').progress()
						end,
					},
				}
			})
			vim.api.nvim_create_autocmd("LspProgress", {
				callback = function()
					lualine.refresh({})
				end
			})
		end
	}
}
