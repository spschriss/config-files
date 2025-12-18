require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"gomod",
		"gotmpl",
		"gowork",
		"graphql",
		"json",
		"json5",
		"luadoc",
		"make",
		"dockerfile",
		"yaml",
		"xml",
		"javascript",
		"rust",
	},
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	refactor = {
		highlight_current_scope = {
			enable = true,
		},
		highlight_definitions = {
			enable = true,
			clear_on_cursor_move = true,
		},
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
			},
		},
	},
})
