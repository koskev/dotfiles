return {
	'mfussenegger/nvim-lint',
	config = function()
		local lint = require('lint')
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				lint.try_lint()
			end,
		})

		lint.linters.jsonnet_linter = {
			cmd = "jsonnet-lint",
			stdin = false,
			append_fname = true,
			args = {},
			stream = nil,
			ignore_exitcode = false,
			env = nil,
		}

		lint.linters_by_ft = {
			jsonnet = { "jsonnet_linter" },
			libsonnet = { "jsonnet_linter" }
		}
	end
}
