-- Colorscheme
vim.cmd('syntax on')

-- citruszest --
-- vim.cmd([[colorscheme citruszest]])


-- monokai-pro --
-- monokai-pro.nvim/lua/monokai-pro/theme/editor.lua
-- monokai-pro.nvim/lua/monokai-pro/theme/syntax.lua
--[[
require("monokai-pro").setup({
	override = function()
		return {
			Normal = { bg = "#101010" },
			Type = { fg = "#0BDF52", italic = true },
		}
	end
})
]]--
-- vim.cmd([[colorscheme monokai-pro]])


-- tokyonight --
-- local util = require("tokyonight.util")
require("tokyonight").setup({
	-- use the night style
	style = "night",
	-- disable italic for functions
	--[[
	styles = {
		functions = {}
	},
	]]--

	on_highlights = function(highlights, colors)
		highlights.LineNr = {
			fg = colors.dark5
			-- bg = "#3b4261",
			-- bold = true,
		}
	end

})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "SignifySignAdd", { fg = "#c3e88d", bold = true })
		vim.api.nvim_set_hl(0, "SignifySignDelete", { fg = "#ffc777", bold = true })
		vim.api.nvim_set_hl(0, "SignifySignChange", { fg = "#ff007c", bold = true })
	end,
})

vim.cmd([[colorscheme tokyonight]])


-- General Settings --
-- Override Highlighting Setting
vim.api.nvim_set_hl(0, "ColorColumn", {bg = "#4B0082"})
-- For C, C++, ASM
vim.cmd('filetype plugin on')
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "h", "hpp", "cc", "c++", "asm"},
  command = "set colorcolumn=88"
})
