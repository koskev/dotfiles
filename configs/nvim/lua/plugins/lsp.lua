-- All lsp related config. mason-lspconfig initializes all lsps.
-- See https://lsp-zero.netlify.app/docs/tutorial.html
return {
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require('mason').setup({})

			-- Goimports on save
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					local params = vim.lsp.util.make_range_params()
					params.context = { only = { "source.organizeImports" } }
					-- buf_request_sync defaults to a 1000ms timeout. Depending on your
					-- machine and codebase, you may want longer. Add an additional
					-- argument after params if you find that you have to write the file
					-- twice for changes to be saved.
					-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end
					vim.lsp.buf.format({ async = false })
				end
			})


			require("mason-lspconfig").setup({
				ensure_installed = {},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSPs
				"rust_analyzer",
				"gopls",
				"helm_ls",
				"yamlls",
				--				"jsonnet_ls",
				"jedi_language_server",
				-- Debugger
				"delve",
				-- Formatter
				"goimports",
				"gomodifytags",
				"jsonnetfmt",
				-- Other tools
			}
		}
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- Go
					-- Add tags like json to structs
					null_ls.builtins.code_actions.gomodifytags,
					null_ls.builtins.formatting.packer,


				}
			})
		end
	},
}
