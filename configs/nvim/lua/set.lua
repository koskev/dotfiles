vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.listchars = { tab = "→ ", trail = "·" }
vim.opt.list = true
-- Enable middle mouse paste
vim.opt.mouse = ""

-- vim.cmd("set notimeout")

-- vim.cmd("au BufWrite *.go :silent !goimports -w %")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Exit terminal mode with esc
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.lsp.inlay_hint.enable(true, nil)

local function toggle_inlay()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.keymap.set("n", "ti", toggle_inlay, { desc = "Toggle inlay hints" })
--if vim.version().minor >= 11 then
--	vim.diagnostic.config({
--		virtual_lines = true
--	})
--else
--	vim.diagnostic.config({
--		virtual_text = true,
--	})
--end

vim.filetype.add({
	extension = {
		vrl = "vrl",
	}
})

-- vim.highlight.priorities.semantic_tokens = 95

--local autocmd = vim.api.nvim_create_autocmd
--autocmd("FileType", {
--	pattern = "jsonnet",
--	callback = function()
--		local root_dir = vim.fs.dirname(
--			vim.fs.find({ 'go.mod', 'go.work', '.git' }, { upward = true })[1]
--		)
--		local client = vim.lsp.start({
--			name = 'rjsonnet',
--			cmd = { 'env', 'RUST_BACKTRACE=full', 'jsonnet-ls' },
--			root_dir = root_dir,
--		})
--		vim.lsp.buf_attach_client(0, client)
--	end
--})

-- local autocmd = vim.api.nvim_create_autocmd
-- autocmd("FileType", {
-- 	pattern = "jsonnet",
-- 	callback = function()
-- 		local root_dir = vim.fs.dirname(
-- 			vim.fs.find({ 'go.mod', 'go.work', '.git' }, { upward = true })[1]
-- 		)
-- 		local rpc_client = vim.lsp.rpc.connect("127.0.0.1", "4874")
-- 		local client = vim.lsp.start({
-- 			name = 'rjsonnet',
-- 			cmd = rpc_client,
-- 			root_dir = root_dir,
-- 		})
-- 		vim.lsp.buf_attach_client(0, client)
-- 	end
-- })
