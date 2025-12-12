-- Key mappings
require("custom_keymap");

-- Set the Leader key to comma
-- vim.g.mapleader = ","

-- function key
vim.api.nvim_set_keymap('n', '<F3>', ':Telescope file_browser<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F4>', ':Vista!!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F5>', ':Telescope fd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F6>', ':noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F7>', ':LspClangdSwitchSourceHeader<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F8>', ':LspStop<CR>', { noremap = true })

-- buffers
vim.api.nvim_set_keymap('n', 'q', ':bd!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-x>', ':q!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-t>', ':enew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-PageUp>', ':bprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-PageDown>', ':bnext<CR>', { noremap = true })

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

-- Manpager
vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  group = vim.api.nvim_create_augroup("ManUserConfigs", { clear = true }),
  callback = function(evt)
    -- overwrite q-mapping in runtime/ftplugin/man.vim
     vim.keymap.set("n", "q", ":bd!<CR>", { buffer = evt.buf, desc = "Quit(man)" })
  end,
})

-- man
vim.keymap.set("n", "K", function()
	keymap_fn_man_open()
end, { silent = true })

-- Convert comment style
vim.keymap.set({ "n", "i", "v" }, "<leader>lc", function()
	cpp_comment_to_c_comment()
end, {
  desc = "Convert C++ // comment block to C /* */ (visual-safe)",
})

vim.keymap.set({ "n", "i", "v" }, "<leader>cl", function()
	c_comment_to_cpp_comment()
end, {
  desc = "Convert C block comment (/* */) to C++ // comments (visual-safe)",
})


