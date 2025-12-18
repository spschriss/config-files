call plug#begin()
	Plug 'nvim-lua/plenary.nvim'
	" Language servers
	Plug 'neovim/nvim-lspconfig'	
	" Syntax Highlighting
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	" Debugging
	Plug 'folke/neodev.nvim'
	Plug 'mfussenegger/nvim-dap'
	Plug 'nvim-neotest/nvim-nio'
	Plug 'rcarriga/nvim-dap-ui'
	Plug 'leoluz/nvim-dap-go'
	Plug 'David-Kunz/jester'
	" Unit Testing
	Plug 'antoinemadec/FixCursorHold.nvim'
	Plug 'nvim-neotest/nvim-nio'
	Plug 'nvim-neotest/neotest'
	Plug 'nvim-neotest/neotest-go'
	Plug 'nvim-neotest/neotest-jest'
	" Fuzzy finder
	Plug 'nvim-telescope/telescope.nvim'
	" File and Folder Navigation
	Plug 'nvim-tree/nvim-tree.lua'
	" Gutter component for feedback
	Plug 'nvim-lualine/lualine.nvim'
	" Version Control
	Plug 'lewis6991/gitsigns.nvim'
	" Theme Icons
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'projekt0n/github-nvim-theme'
call plug#end()

lua <<EOF
require('init')
EOF

set number
syntax on
colorscheme github_dark
syntax enable
filetype plugin indent on
language en_US

augroup SpellCheck
  autocmd!
  autocmd BufRead,BufNewFile * setlocal spell
augroup END

