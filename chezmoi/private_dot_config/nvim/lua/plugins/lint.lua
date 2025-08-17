return {
	"mfussenegger/nvim-lint",
	config = function()
		require('lint').linters_by_ft = {
			nix = {'statix'},
		}
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()

				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				require("lint").try_lint()

			end,
		})
	end
}
