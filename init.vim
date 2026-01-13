call plug#begin()
	" Language Servers
	Plug 'neovim/nvim-lspconfig'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	" Auto Complete
	" https://github.com/hrsh7th/nvim-cmp
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	" Parsers
	Plug 'nvim-treesitter/nvim-treesitter'
	" File System
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nvim-tree/nvim-web-devicons'
	" Fuzzy Finders
	Plug 'nvim-lua/plenary.nvim'
	" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install' }
	Plug 'nvim-telescope/telescope.nvim', { 'tag': 'v0.2.0' }
	" Version Control
	Plug 'lewis6991/gitsigns.nvim'
	" Theme
	Plug 'EdenEast/nightfox.nvim'
call plug#end()

lua require('init')
set number
syntax on
colorscheme carbonfox 

