local github_copilot_authinfo = vim.env.HOME .. "/.config/github-copilot/apps.json"

local file = io.open(github_copilot_authinfo, "r")
if file then
	local content = file:read("*a")
	file:close()

	if content:find('"oauth_token"') then
		vim.b.copilot_enabled = true
	else
		vim.b.copilot_enabled = false
	end
else
	vim.b.copilot_enabled = false
end

