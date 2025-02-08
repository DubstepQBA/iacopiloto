local client = require("chatgpt.client")
local ui = require("chatgpt.ui")

local function setup(config)
	client.setup(config)
end

vim.api.nvim_create_user_command("ChatGPT", function(opts)
	ui.open_window()
	ui.ask(opts.args)
end, { nargs = "*" })

return {
	setup = setup,
}
