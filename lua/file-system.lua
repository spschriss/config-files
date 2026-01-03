-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local VIEW_WIDTH_FIXED = 30
local view_width_max = VIEW_WIDTH_FIXED -- fixed to start

-- toggle the width and redraw
local function toggle_width_adaptive()
	if view_width_max == -1 then
		view_width_max = VIEW_WIDTH_FIXED
	else
		view_width_max = -1
	end

	require("nvim-tree.api").tree.reload()
end

-- get current view width
local function get_view_width_max()
	return view_width_max
end

vim.keymap.set('n', 'A', toggle_width_adaptive)

-- OR setup with some options
require("nvim-tree").setup({
	auto_reload_on_write = true,
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		severity = {
			min = vim.diagnostic.severity.WARN,
			max = vim.diagnostic.severity.ERROR,
		}
	},
	git = {
		enable = true
	},
	renderer = {
		group_empty = true,
		highlight_git = "name",
		highlight_diagnostics = "name",
		highlight_modified = "name",
	},
	filters = {
		enable = true,
		dotfiles = false,
		git_ignored = false,
	},
	modified = {
		enable = true,
	},
	sort = {
		sorter = "case_sensitive",
	},
	update_focused_file = {
		enable = true,
	},
	view = {
		width = {
			min = VIEW_WIDTH_FIXED,
			max = get_view_width_max,
		},
	},

})
