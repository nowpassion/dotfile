-- Set up nvim-cmp.
local cmp = require("cmp")

vim.opt.completeopt = "menu,menuone,noselect"

local lsp_symbols = {
    Array = "[]",
    Boolean = "",
    Class = "󰠱",
    Color = "󰏘",
    Constant = "󰏿",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "󰜢",
    File = "󰈚",
    Folder = "",
    Function = "󰆧",
    Interface = "",
    Key = "󰌆",
    Keyword = "󰌆",
    Method = "",
    Module = "󰏖",
    Namespace = "󰌗",
    Null = "󰟢",
    Number = "",
    Object = "󰅩",
    Operator = "󰆕",
    Package = "",
    Property = "󰜢",
    Reference = "󰈇",
    Snippet = "",
    String = "",
    Struct = "󰙅",
    Text = "󰀬",
    TypeParameter = "󰊄",
    Unit = "󰑭",
    Value = "󰎠",
    Variable = "󰀫",
}

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
		-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
		-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		--[[
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		]]--
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<PageUp>"] = function(fallback)
			for i = 1, 5 do
				cmp.mapping.select_prev_item()(fallback)
			end
		end,
		["<PageDown>"] = function(fallback)
			for i = 1, 5 do
				cmp.mapping.select_next_item()(fallback)
			end
		end,
	}),
	formatting = {
		format = function(entry, item)
			item.kind = lsp_symbols[item.kind] .. " " .. item.kind
			-- set a name for each source
			item.menu =
			({
				spell = "[Spell]",
				buffer = "[Buffer]",
				calc = "[Calc]",
				emoji = "[Emoji]",
				nvim_lsp = "[LSP]",
				path = "[Path]",
				look = "[Look]",
				treesitter = "[treesitter]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
				cmp_tabnine = "[Tab9]"
			})[entry.source.name]
			return item
		end
    },
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip', option = { use_show_condition = false, show_autosnippets = true } }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
	{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
--[[
	mapping = cmp.mapping.preset.insert({
		['<Down>'] = {
			c = function()
				local cmp = require('cmp')
				if cmp.visible() then
					cmp.select_next_item()
				end
			end,
		},
		['<Up>'] = {
			c = function()
				local cmp = require('cmp')
				if cmp.visible() then
					cmp.select_prev_item()
				end
			end,
		},
		['<Tab>'] = {
			c = function(_)
				if cmp.visible() then
					if #cmp.get_entries() == 1 then
						cmp.confirm({ select = true })
					else
						cmp.select_next_item()
					end
				else
					cmp.complete()
					if #cmp.get_entries() == 1 then
						cmp.confirm({ select = true })
					end
				end
			end,
		}
	}),
]]--
	sources = cmp.config.sources({
	{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

