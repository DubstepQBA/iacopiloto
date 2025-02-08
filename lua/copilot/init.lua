local M = {}

-- Configuración por defecto
M.config = {
	api_key = nil, -- Debes proporcionar tu API key
	model = "gpt-4o", -- Modelo de ChatGPT
	max_tokens = 1000, -- Máximo número de tokens en la respuesta
}

-- Función para configurar el plugin
function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", M.config, opts)
	if not M.config.api_key then
		error("API key de OpenAI no configurada")
	end
end

-- Función para enviar una solicitud a la API de ChatGPT
function M.query(prompt)
	local http = require("plenary.http")
	local json = require("json")

	local url = "https://api.openai.com/v1/chat/completions"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. M.config.api_key,
	}

	local body = json.encode({
		model = M.config.model,
		messages = { { role = "user", content = prompt } },
		max_tokens = M.config.max_tokens,
	})

	local response = http.post(url, {
		headers = headers,
		body = body,
	})

	if response.status ~= 200 then
		error("Error al comunicarse con la API de OpenAI: " .. response.body)
	end

	local result = json.decode(response.body)
	return result.choices[1].message.content
end

return M
