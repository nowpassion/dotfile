-- luasnip + friendly-snippets
local luasnip = require("luasnip")

-- friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- add custom snippets dir to lazy load
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" }
})

--- Create a keymap that expands a snippet from vscode style snippets
--- opts = {
---     key = "<leader>c",        -- required: keymap
---     trigger = "cmm",          -- required: snippet trigger to expand
---     filetypes = {"c", "cpp"}, -- optional: restrict to these filetypes
---     mode = { "i", "n" },      -- optional: default both normal+insert
---     desc = "Expand snippet",  -- optional: description
--- }
local function create_snippet_keymap(opts)
	vim.keymap.set(opts.mode or { "n", "i" }, opts.key, function()
		local ft = vim.bo.filetype

		-- If filetypes are specified, ensure current ft is allowed
		if opts.filetypes and not vim.tbl_contains(opts.filetypes, ft) then
			print("Snippet not available for filetype: " .. ft)
			return
		end

		-- Load snippets for this filetype
		local snippets = luasnip.get_snippets(ft)

		-- Find the target snippet by trigger
		for _, snip in ipairs(snippets or {}) do
			if snip.trigger == opts.trigger then
				luasnip.snip_expand(snip)
				return
			end
		end

		print("Snippet '" .. opts.trigger .. "' not found for filetype: " .. ft)
	end, { desc = opts.desc or ("Expand snippet: " .. opts.trigger) })
end

-- np (nowpassion) custom snippets
-- CHECK ~/.config/nvim/snippets 
local mappings = {
	{
		key = "<Leader>ncm",
		trigger = "np_custom_mcomment",
		filetypes = { "c", "cpp", "h" },
		desc = "Insert C multi-line comment block",
	},
	{
		key = "<Leader>ncs",
		trigger = "np_custom_switchcase",
		filetypes = { "c", "cpp" },
		desc = "Insert switch/case",
	},
}

for _, m in ipairs(mappings) do
    create_snippet_keymap(m)
end


