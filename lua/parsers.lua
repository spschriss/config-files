require('nvim-treesitter').install({
	'go',
	'typescript',
	'javascript',
	'json',
	'markdown',
	'lua',
	'nginx',
	'dot',
	"dockerfile",
	"jsx",
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'txt,go,html,css,js,jsx,ts,tsx,markdown,md,env' },
  callback = function()
	  vim.treesitter.start()
	  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	  vim.wo[0][0].foldmethod = 'expr'
	  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
