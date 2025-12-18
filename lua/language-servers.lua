-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { "menuone", "noselect" }
vim.lsp.set_log_level("debug")
-- vim.o.foldmethod = 'expr'
-- Default to treesitter folding
-- vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- Add nvim-lspconfig plugin
local on_attach = function(client, bufnr)
	local attach_opts = {
		silent = true,
		buffer = bufnr,
	}
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
			'pumvisible() ? "<C-n>" : "<Tab>"',
			{ expr = true, noremap = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"s",
			"<Tab>",
			'pumvisible() ? "<C-n>" : "<Tab>"',
			{ expr = true, noremap = true }
		)

		-- Accept the selected completion item with Enter
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"i",
			"<CR>",
			'pumvisible() ? "<C-y>" : "<CR>"',
			{ expr = true, noremap = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"s",
			"<CR>",
			'pumvisible() ? "<C-y>" : "<CR>"',
			{ expr = true, noremap = true }
		)

		-- Optionally, you can also add Shift + Tab for backward navigation
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"i",
			"<S-Tab>",
			'pumvisible() ? "<C-p>" : "<S-Tab>"',
			{ expr = true, noremap = true }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"s",
			"<S-Tab>",
			'pumvisible() ? "<C-p>" : "<S-Tab>"',
			{ expr = true, noremap = true }
		)
	end

	if client:supports_method("textDocument/declaration") then
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, attach_opts)
	end
	if client:supports_method("textDocument/definition") then
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, attach_opts)
	end
	if client:supports_method("textDocument/references") then
		vim.keymap.set("n", "gr", vim.lsp.buf.references, attach_opts)
		vim.keymap.set("n", "so", require("telescope.builtin").lsp_references, attach_opts)
	end
	if client:supports_method("textDocument/hover") then
		vim.keymap.set("n", "K", vim.lsp.buf.hover, attach_opts)
	end
	if client:supports_method("textDocument/implementation") then
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, attach_opts)
	end
	if client:supports_method("textDocument/signatureHelp") then
		vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, attach_opts)
	end
	if client:supports_method("textDocument/diagnostic") or client:supports_method("textDocument/publishDiagnostics") then
		vim.keymap.set("n", "<leader>of", vim.diagnostic.open_float, attach_opts)
		vim.keymap.set("n", "<leader>pe", vim.diagnostic.get_prev, attach_opts)
		vim.keymap.set("n", "<leader>ne", vim.diagnostic.get_next, attach_opts)
	end
	-- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeAction
	if client:supports_method("textDocument/codeAction") then
		vim.keymap.set("n", "ca", vim.lsp.buf.code_action, attach_opts)
	end
	if client:supports_method("workspace/workspaceFolders") then
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, attach_opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, attach_opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, attach_opts)
	end
	if client:supports_method("textDocument/definition") then
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, attach_opts)
	end
	if client:supports_method("textDocument/rename") then
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, attach_opts)
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
	if client:supports_method("textDocument/foldingRange") then
		local win = vim.api.nvim_get_current_win()
		vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.config("ls_ts", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
vim.lsp.config("gopls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#graphql
vim.lsp.config("graphql", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
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
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.config("docker_compose_language_service", {
	on_attach = on_attach,
	capabilities = capabilities,
})
vim.lsp.config("angularls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
vim.lsp.config("cssls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
vim.lsp.config("html", {
	on_attach = on_attach,
	capabilities = capabilities,
})
vim.lsp.config("jsonls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#sqls
vim.lsp.config("sqls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#stylua
vim.lsp.config("stylua", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vimls
vim.lsp.config("vimls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#eslint
vim.lsp.config("eslint", {
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "LspEslintFixAll",
		})
	end,
	capabilities = capabilities,
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vimls
vim.lsp.enable("vimls")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#templ
vim.lsp.enable("stylua")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#sqls
vim.lsp.enable("sqls")
vim.lsp.enable("html")
vim.lsp.enable("graphql")
vim.lsp.enable("jsonls")
vim.lsp.enable("cssls")
vim.lsp.enable("ls_ts")
vim.lsp.enable("gopls")
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.enable("lua_ls")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("angularls")
vim.lsp.enable("eslint")
