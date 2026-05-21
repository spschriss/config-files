local function safe_setup(name, opts)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.notify("plugin not loaded: " .. name .. " (run :PlugInstall)", vim.log.levels.WARN)
    return nil
  end
  if mod.setup then mod.setup(opts or {}) end
  return mod
end

safe_setup("nvim-treesitter.configs", {
  ensure_installed = {
    "lua", "vim", "vimdoc", "query",
    "typescript", "tsx", "javascript", "html", "css", "json",
    "markdown", "markdown_inline",
    "rust", "bash",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

safe_setup("which-key")
safe_setup("Comment")
safe_setup("nvim-autopairs")

local cmp_ok, cmp = pcall(require, "cmp")
local pairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if cmp_ok and pairs_ok then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
