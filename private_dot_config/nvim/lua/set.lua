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

vim.cmd("au BufWrite *.rs :Autoformat")
-- vim.cmd("au BufWrite *.tsx :Autoformat")