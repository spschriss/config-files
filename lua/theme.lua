-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- nvim-tree and tabby are configured in fs.lua (loaded before theme).
-- Do NOT call setup() here with no args — it resets nvim-tree to defaults
-- (filters.git_ignored = true), which re-hides .env and other gitignored files.

vim.o.showtabline = 2
vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
