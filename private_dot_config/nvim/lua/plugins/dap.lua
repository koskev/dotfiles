-- All debugger related plugins
return {
	{
		'mfussenegger/nvim-dap',
		config = function ()
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
		dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
		config = function ()
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
		opts = {}
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		config = function ()
			require("telescope").load_extension("dap")
		end
	},
	{
		-- Shows the current values of variables inside code
		"theHamsta/nvim-dap-virtual-text",
		opts = {}
	}
}
