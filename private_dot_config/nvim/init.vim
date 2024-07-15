let mapleader = "\<Space>"

nnoremap <leader>p :NvimTreeToggle<CR>
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope commands<cr>

" Automatic load vim-plug
lua require('plugins')
lua require('lsp')
lua require('rt')
" Auto cargo versions stuff
autocmd BufRead Cargo.toml call crates#toggle()
" Autoformat on Save
au BufWrite *.rs :Autoformat
" My config
set number
set relativenumber
syntax on
set showcmd
set encoding=utf-8
set list listchars=tab:→\ ,trail:·
" YouCompleteMe settings
let g:ycm_min_num_of_chars_for_completion = 1
" Remove arrows keys in normal mode for training
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
colorscheme mytorte
" Cquery
"let g:LanguageClient_serverCommands = {
"    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
"    \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
"    \ }


let g:LanguageClient_serverCommands = {
			\ 'cpp': ['clangd'],
			\ 'c': ['clangd'],
			\ 'rust': ['rust-analyzer'],
			\ }

let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()

nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
let g:deoplete#enable_at_startup = 1
" Deoplete tab
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
"echodoc
set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'
" Auto clang format on save
autocmd FileType c ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable

set tabstop=4
set shiftwidth=4
set noexpandtab
" Override python stuff
au BufNewFile,BufRead *.py
			\ set noexpandtab |
			\ set shiftwidth=4 |
			\ set tabstop=4

" Disable auto format if no .clang-format is found
let g:clang_format#enable_fallback_style = 0

" Yoink settings
let g:yoinkIncludeDeleteOperations = 1
let g:yoinkSavePersistently = 1
" Save undo history
set undofile
set undodir=/tmp
" Enable middle mouse pasting
set mouse=""
noremap <F7> :'<,'>! prettier --parser html --stdin-filepath<cr>

