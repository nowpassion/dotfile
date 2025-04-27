-- Colorscheme
vim.cmd('syntax on')

-- monokai-pro.nvim/lua/monokai-pro/theme/editor.lua
-- monokai-pro.nvim/lua/monokai-pro/theme/syntax.lua
require("monokai-pro").setup({
	override = function()
		return {
			Normal = { bg = "#101010" },
			Type = { fg = "#FF6188" },
		}
	end
})

vim.cmd([[colorscheme monokai-pro]])

-- vim.cmd([[colorscheme tokyonight-night]])
-- vim.cmd([[colorscheme citruszest]])

-- Override Highlighting Setting
vim.api.nvim_set_hl(0, "ColorColumn", {bg = "#4B0082"})
-- For C, C++, ASM
vim.cmd('filetype plugin on')
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "h", "hpp", "cc", "c++", "asm"},
  command = "set colorcolumn=88"
})
