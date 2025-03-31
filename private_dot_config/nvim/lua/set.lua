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

vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.lsp.inlay_hint.enable(true, nil)

local function toggle_inlay()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.keymap.set("n", "ti", toggle_inlay, { desc = "Toggle inlay hints" })
if vim.version().minor == 11 then
	vim.diagnostic.config({
		virtual_lines = true
	})
else
	vim.diagnostic.config({
		virtual_text = true,
	})
end
