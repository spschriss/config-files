local api = vim.api
-- required for type hinting during debugging
require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})
-- automatically open and close when attaching
local dap, dapui = require("dap"), require("dapui")
require('dapui').setup()
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
	api.nvim_command('NvimTreeClose');
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
	api.nvim_command('NvimTreeClose');
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
	api.nvim_command('NvimTreeOpen');
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
	api.nvim_command('NvimTreeOpen');
end

require('dap-go').setup({})
