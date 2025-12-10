local github_copilot_authinfo = vim.env.HOME .. "/.config/github-copilot/apps.json"

local file = io.open(github_copilot_authinfo, "r")
if file then
	local content = file:read("*a")

	if content:find('"oauth_token"') == nil then
		vim.g.loaded_copilot = 1;
	end

	file:close()
else
	vim.g.loaded_copilot = 1;
end

