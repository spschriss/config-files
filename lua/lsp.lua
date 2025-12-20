--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('*', {
  capabilities = capabilities,
});

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cssls
vim.lsp.enable('cssls')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#docker_compose_language_service
vim.lsp.enable('docker_compose_language_service')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#docker_language_server
vim.lsp.enable('docker_language_server')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#eslint
vim.lsp.enable('eslint')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#html
vim.lsp.enable('html')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
vim.lsp.enable('json')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})
vim.lsp.enable('lua_ls')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#stylua
vim.lsp.enable('stylua')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tsgo
vim.lsp.enable('tsgo')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vimls
vim.lsp.enable('vimls')
