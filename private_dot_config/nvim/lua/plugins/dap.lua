-- All debugger related plugins
return {
	{
		'mfussenegger/nvim-dap',
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			vim.keymap.set('n', '<Leader>dc', function() dap.continue() end, { desc = "Continue" })
			vim.keymap.set('n', '<Leader>dso', function() dap.step_over() end, { desc = "Step over" })
			vim.keymap.set('n', '<Leader>dsi', function() dap.step_into() end, { desc = "Step into" })
			vim.keymap.set('n', '<Leader>dsb', function() dap.step_out() end, { desc = "Step out" })
			vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, { desc = "Toogle breakpoint" })
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.keymap.set('n', '<Leader>dt', function() dapui.toggle() end, { desc = "Toggle dap ui" })
		end
	},
	{
		"leoluz/nvim-dap-go",
		event = "VeryLazy",
		opts = {}
	},
	--{
	--	dir = "/home/kevin/Dokumente/Projekte/Github/koskev/dap-jsonnet.nvim",
	--	config = function()
	--		require("dap-jsonnet").setup()
	--	end
	--},
	--{
	--	"koskev/dap-jsonnet.nvim",
	--	opts = {
	--		debugger_args = { "--dap", "-s" }
	--	},
	--	dependencies = { 'mfussenegger/nvim-dap' }
	--},
	{
		-- Shows the current values of variables inside code
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		dependencies = { 'mfussenegger/nvim-dap' },
		opts = {}
	}
}
