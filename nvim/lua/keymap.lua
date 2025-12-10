-- Key mappings
-- Set the Leader key to comma
vim.g.mapleader = ","

-- buffers
vim.api.nvim_set_keymap('n', 'q', ':bd!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-x>', ':q!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-t>', ':enew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-PageUp>', ':bprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-PageDown>', ':bnext<CR>', { noremap = true })

-- man
vim.api.nvim_set_keymap('n', '<S-k>', ':Man<CR>', { noremap = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  group = vim.api.nvim_create_augroup("ManUserConfigs", { clear = true }),
  callback = function(evt)
    -- overwrite q-mapping in runtime/ftplugin/man.vim
     vim.keymap.set("n", "q", ":bd!<CR>", { buffer = evt.buf, desc = "Quit(man)" })
  end,
})

-- function key
vim.api.nvim_set_keymap('n', '<F3>', ':Telescope file_browser<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F4>', ':Vista!!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F5>', ':Telescope fd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F6>', ':noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F7>', ':LspClangdSwitchSourceHeader<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F8>', ':LspStop<CR>', { noremap = true })

-- Bufferhint
vim.api.nvim_set_keymap('n', '-', ':call bufferhint#Popup()<CR>', { noremap = true })

-- VC
vim.api.nvim_set_keymap('n', 'gb', ':VCBlame<CR>', { noremap = true })

-- Diagnostic
vim.api.nvim_set_keymap('n', '<C-D>', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Up>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Neogen
-- Generate comment for current line
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)

-- luasnip
local ls = require("luasnip")

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
		local snippets = ls.get_snippets(ft)

		-- Find the target snippet by trigger
		for _, snip in ipairs(snippets or {}) do
			if snip.trigger == opts.trigger then
				ls.snip_expand(snip)
				return
			end
		end

		print("Snippet '" .. opts.trigger .. "' not found for filetype: " .. ft)
	end, { desc = opts.desc or ("Expand snippet: " .. opts.trigger) })
end

local mappings = {
	{
		key = "\\cfr",
		trigger = "mcomment",
		filetypes = { "c", "cpp", "h" },
		desc = "Insert C multi-line comment block",
	},
	{
		key = "\\ss",
		trigger = "switch",
		filetypes = { "c", "cpp" },
		desc = "Insert switch/case",
	},
}

for _, m in ipairs(mappings) do
    create_snippet_keymap(m)
end

-- VimSignify
vim.api.nvim_set_keymap('n', '<A-Down>', ':call sy#jump#next_hunk(v:count1)<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-Up>', ':call sy#jump#prev_hunk(v:count1)<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':SignifyDiff!<CR>:set foldcolumn=0<CR>', { noremap = true })

-- LSP
vim.keymap.set("n", '<A-i>', 
  function() 
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0}) 
  end
)
