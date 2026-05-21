call plug#begin()
	" Language Server
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'L3MON4D3/LuaSnip'
	Plug 'saadparwaiz1/cmp_luasnip'
	" Finder
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'nvim-telescope/telescope.nvim'
	" Theme
	Plug 'EdenEast/nightfox.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nanozuki/tabby.nvim'
	Plug 'lewis6991/gitsigns.nvim'
	" Claude Code
	Plug 'coder/claudecode.nvim'
call plug#end()

set number
syntax enable
filetype plugin indent on
colorscheme carbonfox
" Always show tabline plugin
" vim.o.showtabline = 2
lua require('init')
