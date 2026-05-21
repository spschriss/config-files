require("claudecode").setup({})

local map = vim.keymap.set

map({ "n", "v" }, "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>cr", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>cC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
map("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude diff" })
map("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny Claude diff" })
