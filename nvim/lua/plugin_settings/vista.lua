-- Vista
-- How each level is indented and what to prepend.
-- This could make the display more compact or more spacious.
-- e.g., more compact: ["▸ ", ""]
-- Note: this option only works for the kind renderer, not the tree renderer.
vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }

-- Executive used when opening vista sidebar without specifying it.
-- See all the available executives via `:echo g:vista#executives`.
vim.g.vista_default_executive = 'ctags'

-- Set the executive for some filetypes explicitly.
-- Use the explicit executive instead of the default one for these filetypes 
-- when using `:Vista` without specifying the executive.
--[[
vim.g.vista_executive_for = {
  c = 'nvim_lsp',
  cpp = 'nvim_lsp',
}
--]]

-- Sidebar width
vim.g.vista_sidebar_width = 50

-- Declare the command including the executable and options used to generate
-- ctags output for some certain filetypes. The file path will be appended 
-- to your custom command.
vim.g.vista_ctags_cmd = {
  haskell = 'hasktags -x -o - -c',
}

-- To enable fzf's preview window set g:vista_fzf_preview.
-- The elements of g:vista_fzf_preview will be passed as arguments to 
-- fzf#vim#with_preview().
vim.g.vista_fzf_preview = { 'right:50%' }

-- Ensure you have installed some decent font to show these pretty symbols,
-- then you can enable icon for the kind.
vim.g["vista#renderer#enable_icon"] = 1

-- The default icons can't be suitable for all the filetypes,
-- you can extend it as you wish.
--[[
vim.g["vista#renderer#icons"] = {
  ["function"] = "\u{f794}",
  ["variable"] = "\u{f71b}",
}
--]]