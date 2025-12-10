-- luasnip + friendly-snippets
local luasnip = require("luasnip")

-- friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- add custom snippets dir to lazy load
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" }
})

