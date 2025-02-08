local M = {}

local api_url = "https://api.openai.com/v1/chat/completions"

function M.setup(config)
	M.config = vim.tbl_extend("force", {
		api_key = nil,
		model = "gpt-4",
		max_tokens = 1000,
		temperature = 0.7,
	}, config or {})
end

function M.query(messages, callback)
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. M.config.api_key,
	}

	local body = vim.json.encode({
		model = M.config.model,
		messages = messages,
		max_tokens = M.config.max_tokens,
		temperature = M.config.temperature,
	})

	vim.system(
		{ "curl", "-X", "POST", "-H", headers["Content-Type"], "-H", headers["Authorization"], "-d", body, api_url },
		{ text = true },
		function(obj)
			if obj.code ~= 0 then
				callback(nil, "Error en la solicitud: " .. obj.stderr)
				return
			end

			local response = vim.json.decode(obj.stdout)
			if response.error then
				callback(nil, "API Error: " .. response.error.message)
			else
				callback(response.choices[1].message.content)
			end
		end
	)
end

return M
