require("tabby").setup({
	tabpage = {
		each = function(bufnr, winid, number)
			return {
				type = "window", -- Treats each window as a "tab"
			}
		end,
	},
})
require("nvim-tree").setup({
	filters = {
		enable = false,
		dotfiles = false,
		git_ignored = false,
	},
	git = {
		ignore = false,
	},
	on_attach = function(bufnr)
		-- Apply nvim-tree's default keymaps (Enter, <CR>, etc.)
		require("nvim-tree.api").config.mappings.default_on_attach(bufnr)
	end
})

local telescope = require('telescope')
telescope.load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
	builtin.find_files({
		hidden = true,
		no_ignore = true,
		file_ignore_patterns = { "^%.git/", "node_modules/" },
	})
end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

vim.g.nvim_tree_side = "left"
-- This ensures files open in the window to the right
vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvimTree",
	callback = function()
		vim.api.nvim_set_current_win(vim.api.nvim_get_current_win())
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function(args)
		local api = require("nvim-tree.api")
		if not api.tree.is_visible() then
			return
		end
		local bufname = vim.api.nvim_buf_get_name(args.buf)
		if bufname == "" or vim.bo[args.buf].buftype ~= "" then
			return
		end
		if vim.uv.fs_stat(bufname) == nil then
			return
		end
		api.tree.find_file({ buf = args.buf, focus = false })
	end,
})
