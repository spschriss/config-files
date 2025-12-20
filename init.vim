call plug#begin()
	" Language Servers
	Plug 'neovim/nvim-lspconfig'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

lua require('init')
set number
syntax on

