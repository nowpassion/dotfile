--
-- vim.opt
--
-- Form
vim.opt.cp = false
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.swapfile = false
vim.opt.expandtab = false

-- Terminal
vim.opt.termguicolors = true

vim.opt.laststatus = 2
vim.opt.ruler = true -- 커서 위치 항상 보이기
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkon250'

-- Highlighting
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true

-- Tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- For C, C++, ASM
vim.cmd('filetype plugin on')
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "h", "hpp", "cc", "c++", "asm"},
  command = "set colorcolumn=88"
})

-- Encoding
vim.opt.fileencodings = {'utf-8', 'euc-kr'}

-- Mouse
vim.opt.mouse = ''

-- buffers
vim.cmd('set hidden')

--
-- Plugins
--
vim.cmd('call plug#begin()')

-- Colorscheme
vim.cmd [[
Plug 'zootedb0t/citruszest.nvim'
Plug 'folke/tokyonight.nvim'
]]

-- lualine, bufferline
vim.cmd [[
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
]]

-- Other plugins
vim.cmd [[
Plug 'juneedahamed/vc.vim'
Plug 'liuchengxu/vista.vim'
Plug 'bsdelf/bufferhint' "opened buffer list 
Plug 'nathanaelkane/vim-indent-guides'
Plug 'folke/which-key.nvim'
Plug 'mhinz/vim-signify'
]]
--[[
Plug 'simrat39/symbols-outline.nvim'
Plug 'majutsushi/tagbar'	"file var, func
--]]

-- C Project
vim.cmd [[
Plug 'nowpassion/cscope_maps.nvim'
]]

-- LSP and completion
vim.cmd [[
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'ray-x/lsp_signature.nvim'
Plug 'rafamadriz/friendly-snippets'
]]

-- Telescope
vim.cmd [[
Plug 'BurntSushi/ripgrep'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'sharkdp/fd'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'benfowler/telescope-luasnip.nvim'
]]

-- Documentation
vim.cmd [[
Plug 'danymat/neogen'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
]]

-- Copilot
vim.cmd [[
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
]]

vim.cmd('call plug#end()')

-- Colorscheme
vim.cmd('syntax on')
vim.cmd("colorscheme tokyonight-night")
-- vim.cmd("colorscheme citruszest")
-- Override Highlighting Setting
vim.api.nvim_set_hl(0, "ColorColumn", {bg = "#4B0082"})

-- Files
require("plugin_settings.lspconfig")
require("plugin_settings.telescope")
require("plugin_settings.nvim-cmp")
require("plugin_settings.lsp_signature")
require("plugin_settings.bufferline")
require("plugin_settings.lualine")
require("plugin_settings.vista")
require("plugin_settings.symbols-outline")
require("plugin_settings.neogen")
require("plugin_settings.signify")
require("plugin_settings.github_copilot")

require("cws")
require("keymap")

