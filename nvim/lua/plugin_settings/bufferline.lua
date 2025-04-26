-- bufferline
local bufferline = require('bufferline')
bufferline.setup {
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
		themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
		numbers = "ordinal",
		
		close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
		right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
		left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
		middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
	
		indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
			style = 'icon',
		},
		buffer_close_icon = '󰅖 ',
		modified_icon = '● ',
		close_icon = ' ',
		left_trunc_marker = ' ',
		right_trunc_marker = ' ',

		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = true, -- whether or not tab names should be truncated
		tab_size = 18,

		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false, -- only applies to coc
		diagnostics_update_on_event = true, -- use nvim's diagnostic handler
		--[[
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and " "
				or (e == "warning" and " " or " ")
				s = s .. sym .. n .. ' '
			end
			return s
		end,
		]]--

		offset = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true
			}
		},
		color_icons = true, -- whether or not to add the filetype icon highlights
		show_buffer_icons = true, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
		duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "slant",
		enforce_regular_tabs = false,
		always_show_bufferline = false,
		auto_toggle_bufferline = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = {'close'}
		},
		sort_by = 'insert_at_end',
		pick = {
			alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
		},
	},
	highlights = {
		buffer_selected = {
			bg = '#404040',
			bold = true,
			italic = true,
            -- underline = true,
		},
		numbers_selected = {
			bg = '#404040',
			bold = true,
			italic = true,
		},
		separator_selected = {
			bg = '#404040',
		},
		close_button_selected = {
			bg = '#404040',
		},
		modified_selected = {
			bg = '#404040',
		},
		-- LSP Diagnostic
		info_selected = {
			bg = '#404040',
			bold = true,
			italic = true
		},
		warning_selected = {
			bg = '#404040',
			bold = true,
			italic = true
		},
		error_selected = {
			bg = '#404040',
			bold = true,
			italic = true 
		},
		-- LSP Diagnostic indicator
	};
}