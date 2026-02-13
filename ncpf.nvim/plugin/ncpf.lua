-- Init NCPF plugin 
-- Setup autocommand to initialize ncpf for C/C++ files
local ncpf_group = vim.api.nvim_create_augroup('NCPF', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = ncpf_group,
  pattern = { '*.c', '*.h', '*.cpp', '*.hpp', '*.cc' },
  callback = function()
    -- Only initialize once per session
    if not vim.g.ncpf_initialized then
      local ncpf = require('ncpf.ncpf')
      ncpf.init()
      vim.g.ncpf_initialized = true
    end
  end,
  desc = 'Initialize NCPF for C/C++ files'
})
