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

vim.opt.completeopt = {
	"menuone", -- Use the popup menu also when there is only one match. Useful when there is additional information about the match, e.g., what file it comes from.
	"noselect", -- Same as “noinsert”, except that no menu item is pre-selected. If both “noinsert” and “noselect” are present, “noselect” has precedence.
	"popup", -- Show extra information about the currently selected completion in a popup window. Only works in combination with “menu” or “menuone”. Overrides “preview”.
}

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
	}, {
		{ name = "buffer" },
	}),
})

-- https://neovim.io/doc/user/lsp.html#lsp-api
-- https://neovim.io/doc/user/lsp.html#lsp-config
-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
local on_attach = function(client, bufnr)
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
	if client:supports_method("textDocument/definition") then
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, noremap = true, silent = false })
	end
	if
	    client:supports_method("textDocument/diagnostic") or client:supports_method("textDocument/publishDiagnostics")
	then
		vim.keymap.set("n", "[e", vim.diagnostic.open_float, { buffer = bufnr, noremap = true, silent = false })
		vim.diagnostic.config({
			jump = { on_jump = on_jump },
			virtual_lines = true,
		})
	end
	-- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeAction
	if client:supports_method("textDocument/codeAction") then
		vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { buffer = bufnr, noremap = true, silent = false })
	end
	if client:supports_method("textDocument/hover") then
		vim.keymap.set("n", "<S-K>", vim.lsp.buf.hover, { noremap = true, silent = true })
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
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git", ".mod", ".sum" },
	on_attach = on_attach,
})

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
vim.lsp.enable({
	"angularls",
	"cssls",
	"docker_compose_language_service",
	"docker_language_server",
	"dockerls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"marksman",
	"stylua",
	"ts_ls",
	"vimls",
})
