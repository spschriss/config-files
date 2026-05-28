local function safe_setup(name, opts)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.notify("plugin not loaded: " .. name .. " (run :PlugInstall)", vim.log.levels.WARN)
    return nil
  end
  if mod.setup then mod.setup(opts or {}) end
  return mod
end

local ts_ok, ts = pcall(require, "nvim-treesitter")
if ts_ok then
  ts.install({
    "lua", "vim", "vimdoc", "query",
    "typescript", "tsx", "javascript", "html", "css", "json",
    "markdown", "markdown_inline",
    "rust", "bash",
  })
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      if vim.bo[args.buf].filetype ~= "" then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

safe_setup("which-key")
safe_setup("Comment")
safe_setup("nvim-autopairs")

local cmp_ok, cmp = pcall(require, "cmp")
local pairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if cmp_ok and pairs_ok then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
