-- Telescope
require('telescope').setup{
	defaults = {
		path_display={"smart"} 
	}
}

require('telescope').load_extension('file_browser')
require('telescope').load_extension('luasnip')