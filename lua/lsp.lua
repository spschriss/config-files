local conform = require("conform")
require("conform").setup({
  formatters_by_ft = {

  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
})

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
    -- Web stuff
    javascript = { { "prettierd", "prettier" }, "eslint" },
    typescript = { { "prettierd", "prettier" }, "eslint" },
    javascriptreact = { { "prettierd", "prettier" }, "eslint" },
    typescriptreact = { { "prettierd", "prettier" }, "eslint" },
    css = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    json = { { "prettierd", "prettier" } },
    markdown = { { "prettierd", "prettier" } },
    yaml = { { "prettierd", "prettier" } },
    rust = { "rustfmt" },
    lua = { "stylua" },
    go = { "gofmt", "goimports" },
  },
  format_on_save = {
    timeout_ms = 1500,
    lsp_fallback = true,
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
