return {
	'vim-autoformat/vim-autoformat',
	config = function ()
		vim.cmd("au BufWrite *.rs :Autoformat")
		vim.cmd("au BufWrite *.tsx :Autoformat")
		vim.cmd("au BufWrite *.ts :Autoformat")
		vim.cmd("au BufWrite *.go :Autoformat")

	end
}
