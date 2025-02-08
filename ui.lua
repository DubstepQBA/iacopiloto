local M = {}
local client = require("chatgpt.client")

local buf, win = nil, nil

function M.open_window()
	buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = (vim.o.columns - width) / 2,
		row = (vim.o.lines - height) / 2,
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<CR>", { noremap = true })
end

function M.ask(prompt)
	client.query({
		{ role = "user", content = prompt },
	}, function(response, err)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
			"> " .. prompt,
			"",
			vim.split(response, "\n"),
			"",
		})
	end)
end

return M
