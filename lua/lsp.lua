local conform = require("conform")

conform.setup({
  formatters = {
    eslint = {
      command = "eslint",
      args = {
        "--fix",
        "--stdin",
        "--stdin-filename",
        "$FILENAME",
      },
      stdin = true,
    },
  },
  formatters_by_ft = {
    javascript = { "prettierd", "eslint" },
    typescript = { "prettierd", "eslint" },
    javascriptreact = { "prettierd", "eslint" },
    typescriptreact = { "prettierd", "eslint" },
    css = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    rust = { "rustfmt" },
    lua = { "stylua" },
    go = { "gofmt", "goimports" },
  },
  format_on_save = {
    timeout_ms = 1500,
    lsp_format = "fallback",
  },
})

-- lsp.lua
local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "grd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "grD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "E", vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", "gri", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "grn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "grr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "g.", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    conform.format({ async = true, lsp_format = "fallback", range = range })
  end, { range = true })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    -- Tab to navigate snippets and accept
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Apply on_attach + capabilities to every LSP. Per-server blocks below only
-- contain fields that deviate from nvim-lspconfig defaults.
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Angular: scope to .ts and .html only (skip typescriptreact / htmlangular)
vim.lsp.config("angularls", {
  filetypes = { "typescript", "html" },
})

-- somesass_ls: lspconfig ships a typo (`.package.json`); use the correct marker.
vim.lsp.config("somesass_ls", {
  root_markers = { "package.json", ".git" },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable({
  "rust_analyzer",
  "ts_ls",
  "angularls",
  "lua_ls",
  "vimls",
  "jsonls",
  "lemminx",
  "cssls",
  "somesass_ls",
})

vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end
  local lines = {}
  for _, client in ipairs(clients) do
    local cmd = type(client.config.cmd) == "table" and table.concat(client.config.cmd, " ") or "<function>"
    table.insert(lines, string.format("• %s  (id: %d)", client.name, client.id))
    table.insert(lines, string.format("  root: %s", client.root_dir or "none"))
    table.insert(lines, string.format("  cmd:  %s", cmd))
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show attached LSP clients" })

vim.api.nvim_create_user_command("LspRestart", function()
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    vim.lsp.stop_client(client.id)
  end
  vim.defer_fn(function()
    vim.api.nvim_exec_autocmds("FileType", { buf = bufnr })
  end, 500)
end, { desc = "Restart attached LSP clients" })
