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
vim.api.nvim_set_keymap('n', '<F7>', ':ClangdSwitchSourceHeader<CR>', { noremap = true })
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

-- neogen
--[[
-- Generate comment for current line
vim.keymap.set('n', '<Leader>d', '<Plug>(doge-generate)')
-- Interactive mode comment todo-jumping
vim.keymap.set('n', '<TAB>', '<Plug>(doge-comment-jump-forward)')
vim.keymap.set('n', '<S-TAB>', '<Plug>(doge-comment-jump-backward)')
vim.keymap.set('i', '<TAB>', '<Plug>(doge-comment-jump-forward)')
vim.keymap.set('i', '<S-TAB>', '<Plug>(doge-comment-jump-backward)')
vim.keymap.set('x', '<TAB>', '<Plug>(doge-comment-jump-forward)')
vim.keymap.set('x', '<S-TAB>', '<Plug>(doge-comment-jump-backward)')
--]]

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
