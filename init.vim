call plug#begin()
	" Language Servers
	Plug 'neovim/nvim-lspconfig'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	" File System
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nvim-tree/nvim-web-devicons'
	" Fuzzy Finders
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'nvim-telescope/telescope.nvim', { 'tag': 'v0.2.0' }
	" Version Control
	Plug 'lewis6991/gitsigns.nvim'
call plug#end()

lua require('init')
set number
syntax on

