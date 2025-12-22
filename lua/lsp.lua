-- https://neovim.io/doc/user/lsp.html
local virt_lines_ns = vim.api.nvim_create_namespace("on_diagnostic_jump")
--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
local function on_jump(diagnostic, bufnr)
	-- Taken from https://neovim.io/doc/user/diagnostic.html#diagnostic-on-jump-example
	if not diagnostic then
		return
	end
	vim.diagnostic.show(
		virt_lines_ns,
		bufnr,
		{ diagnostic },
		{ virtual_lines = { current_line = true }, virtual_text = false }
	)
end
vim.diagnostic.config({
	jump = { on_jump = on_jump },
	virtual_lines = true,
})

-- https://neovim.io/doc/user/lsp.html#lsp-api
-- https://neovim.io/doc/user/lsp.html#lsp-config
-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { "menuone", "noselect", "popup" }
local on_attach = function(client, bufnr)
	if client:supports_method("textDocument/completion") then
		-- Optional: trigger autocompletion on EVERY keypress. May be slow!
		local chars = {}
		for i = 32, 126 do
			table.insert(chars, string.char(i))
		end
		client.server_capabilities.completionProvider.triggerCharacters = chars
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
		-- Jump to first completion item with Tab
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"i",
			"<Tab>",
			"pumvisible() ? '<C-n>' : '<Tab>'",
			{ expr = true, noremap = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"s",
			"<Tab>",
			"pumvisible() ? '<C-n>' : '<Tab>'",
			{ expr = true, noremap = true }
		)

		-- Accept the selected completion item with Enter
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"i",
			"<CR>",
			"pumvisible() ? '<C-y>': '<CR>'",
			{ expr = true, noremap = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"s",
			"<CR>",
			"pumvisible() ? '<C-y>' : '<CR>'",
			{ expr = true, noremap = true }
		)

		-- Optionally, you can also add Shift + Tab for backward navigation
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"i",
			"<S-Tab>",
			"pumvisible() ? '<C-p>' : '<S-Tab>'",
			{ expr = true, noremap = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"s",
			"<S-Tab>",
			"pumvisible() ? '<C-p>'  : '<S-Tab>'",
			{ expr = true, noremap = true }
		)
	end

	if client:supports_method("textDocument/references") then
		vim.keymap.set(
			"n",
			"so",
			require("telescope.builtin").lsp_references,
			{ buffer = bufnr, noremap = true, silent = false }
		)
	end
	if client:supports_method("textDocument/signatureHelp") then
		vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help,
			{ buffer = bufnr, noremap = true, silent = false })
	end
	if
	    client:supports_method("textDocument/diagnostic") or client:supports_method("textDocument/publishDiagnostics")
	then
		vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float,
			{ buffer = bufnr, noremap = true, silent = false })
	end
	-- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeAction
	if client:supports_method("textDocument/codeAction") then
		vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { buffer = bufnr, noremap = true, silent = false })
	end
	if client:supports_method("workspace/workspaceFolders") then
		vim.keymap.set(
			"n",
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			{ buffer = bufnr, noremap = true, silent = false }
		)
		vim.keymap.set(
			"n",
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ buffer = bufnr, noremap = true, silent = false }
		)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { buffer = bufnr, noremap = true, silent = false })
	end
	if client:supports_method("textDocument/rename") then
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, noremap = true, silent = false })
	end
	-- Support Auto Formatting
	if
	    not client:supports_method("textDocument/willSaveWaitUntil")
	    and client:supports_method("textDocument/formatting")
	then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					id = client.id,
					timeout_ms = 1000,
				})
			end,
		})
	end
	-- Support Folding
	-- see https://neovim.io/doc/user/lsp.html#LspAttach
	--	if client:supports_method('textDocument/foldingRange') then
	--		local win = vim.api.nvim_get_current_win()
	--		vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
	--	end
end
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git", ".mod", ".sum" },
	on_attach = on_attach,
})

local node_path = vim.fn.system("which node")
-- Remove any trailing newline from the node_path
node_path = node_path:gsub("\n", "")

-- Go up one directory
--local parent_dir = node_path:match("(.*/)")             -- Matches everything before the last '/'
--vim.lsp.config("jsonls", {
--	cmd = { parent_dir .. "vscode-json-language-server" }, -- for debian
--})
--vim.lsp.enable("jsonls")
---- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cssls
--vim.lsp.config("cssls", {
--	cmd = { parent_dir .. "vscode-css-language-server" }, -- for debian
--})
--vim.lsp.enable("cssls")
---- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#eslint
--vim.lsp.config("eslint", {
--	cmd = { parent_dir .. "vscode-eslint-language-server" }, -- for debian
--})
--vim.lsp.config("eslint")
---- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#html
--vim.lsp.config("html", {
--	cmd = { parent_dir .. "vscode-html-language-server" }, -- for debian
--})
--vim.lsp.enable("html")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#stylua
-- vim.lsp.enable("stylua")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tsgo

-- vim.lsp.config("tsgo", {
-- 	cmd = {
-- 		-- "/usr/local/bin/node_modules/@typescript/native-preview-darwin-x64/lib/tsgo", -- for macos
-- 		parent_dir .. "tsgo",
-- 	},
-- })
-- vim.lsp.enable("tsgo")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vimls
vim.lsp.enable("vimls")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
			    path ~= vim.fn.stdpath("config")
			    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable("lua_ls")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
vim.lsp.enable("gopls")
