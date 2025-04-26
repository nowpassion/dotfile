-- Signify
vim.g.signify_line_highlight = 0
vim.g.signify_number_highlight = 0
vim.g.signify_realtime = 1
vim.g.signify_vcs_list = { 'git', 'svn', 'cvs' }
vim.api.nvim_create_autocmd("User", {
  pattern = "SignifyHunk",
  callback = function()
    local h = vim.fn['sy#util#get_hunk_stats']()
    if not vim.tbl_isempty(h) then
      print(string.format('[ Hunk %d / %d ]', h.current_hunk, h.total_hunks))
    end
  end
})