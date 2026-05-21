-- lsp.lua
local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "grd", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "grD", vim.lsp.buf.definition, bufopts)
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
end

-- Add this to your on_attach or a separate block
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- completion.lua

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

-- Command-line completion
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

-- Rust
vim.lsp.config("rust_analyzer", {
  on_attach = on_attach,
  capabilities = capabilities,
  -- cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml", "rust-project.json" },
 -- settings = {
 --   ["rust-analyzer"] = {
 --     cargo = { allFeatures = true },
 --     checkOnSave =  true,
 --   },
 -- },
})

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = {
      "package.json",
      "package-lock.json",
      "pnpm-workspace.yaml",
      "pnpm-workspace.yml",
      "yarn.lock",
      "pnpm-lock.yaml",
      "pnpm-lock.yml",
      "tsconfig.json",
      "jsconfig.json",
  },
})

-- Angular
vim.lsp.config("angularls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { "angular.json", "nx.json", "project.json" },
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
})

-- Vim script
vim.lsp.config("vimls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { ".git", "init.vim", "init.lua" },
  filetypes = { "vim" },
})

-- JSON
vim.lsp.config("jsonls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { ".git", "package.json" },
  filetypes = { "json", "jsonc" },
})

-- XML
vim.lsp.config("lemminx", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { ".git" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
})

-- CSS / SCSS / LESS
vim.lsp.config("cssls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { "package.json", ".git" },
  filetypes = { "css", "scss", "less" },
})

-- Sass (indented syntax)
vim.lsp.config("somesass_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { "package.json", ".git" },
  filetypes = { "scss", "sass", "css" },
})

-- Lua
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  -- cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc" },
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

-- Enable them all
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
