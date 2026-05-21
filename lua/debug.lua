local dap_ok, dap = pcall(require, "dap")
local dapui_ok, dapui = pcall(require, "dapui")
local vsjs_ok, dap_vscode_js = pcall(require, "dap-vscode-js")
if not (dap_ok and dapui_ok and vsjs_ok) then
  vim.notify("DAP plugins not loaded (run :PlugInstall)", vim.log.levels.WARN)
  return
end

local vt_ok, virtual_text = pcall(require, "nvim-dap-virtual-text")
if vt_ok then virtual_text.setup({}) end
dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

local js_debug_path = vim.fn.stdpath("data") .. "/debuggers/vscode-js-debug"
local firefox_debug_path = vim.fn.stdpath("data") .. "/debuggers/vscode-firefox-debug"

dap_vscode_js.setup({
  debugger_path = js_debug_path,
  adapters = { "pwa-node", "node-terminal" },
})

dap.adapters.firefox = {
  type = "executable",
  command = "node",
  args = { firefox_debug_path .. "/dist/adapter.bundle.js" },
}

local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

for _, ft in ipairs(js_filetypes) do
  dap.configurations[ft] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current file (Node + tsx)",
      runtimeExecutable = "node",
      runtimeArgs = { "--import=tsx" },
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Node process (--inspect)",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest test (current file)",
      runtimeExecutable = "node",
      runtimeArgs = {
        "${workspaceFolder}/node_modules/.bin/jest",
        "--runInBand",
        "--no-coverage",
        "${file}",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      sourceMaps = true,
    },
    {
      type = "firefox",
      request = "attach",
      name = "Attach to Firefox tab",
      url = function()
        return vim.fn.input("URL: ", "http://localhost:3000")
      end,
      webRoot = "${workspaceFolder}",
      firefoxExecutable = "/Applications/Firefox.app/Contents/MacOS/firefox",
    },
  }
end

local map = vim.keymap.set
map("n", "<F5>",  function() dap.continue() end,         { desc = "DAP continue" })
map("n", "<F10>", function() dap.step_over() end,        { desc = "DAP step over" })
map("n", "<F11>", function() dap.step_into() end,        { desc = "DAP step into" })
map("n", "<F12>", function() dap.step_out() end,         { desc = "DAP step out" })
map("n", "<leader>db", function() dap.toggle_breakpoint() end,                            { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end,    { desc = "Conditional breakpoint" })
map("n", "<leader>dr", function() dap.repl.open() end,    { desc = "Open DAP REPL" })
map("n", "<leader>dl", function() dap.run_last() end,     { desc = "Re-run last debug" })
map("n", "<leader>du", function() dapui.toggle() end,     { desc = "Toggle DAP UI" })
map("n", "<leader>dt", function() dap.terminate() end,    { desc = "Terminate session" })
