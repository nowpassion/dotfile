-- cscope_wrapper_setup.lua
local cws = {

}

opts = {
  -- maps related defaults
  disable_maps = true, -- "true" disables default keymaps
  skip_input_prompt = false, -- "true" doesn't ask for input

  -- cscope related defaults
  cscope = {
    -- location of cscope db file
    db_file = "./cscope.out",
    -- cscope executable
    exec = "cscope", -- "cscope" or "gtags-cscope"
    -- choose your fav picker
    picker = "telescope", -- "telescope", "fzf-lua" or "quickfix"
    -- "true" does not open picker for single result, just JUMP
    skip_picker_for_single_result = true, -- "false" or "true"
    -- these args are directly passed to "cscope -f <db_file> <args>"
    db_build_cmd_args = { "-bqkv" },
    -- statusline indicator, default is cscope executable
    statusline_indicator = nil,
	-- if db_absoulute_path is true, source path is absoulute.
	db_absoulute_path = true,
  }
}

cws.setup = function(db_path) 
	opts.cscope.db_file = db_path
	require("cscope_maps").setup(opts)
end

return cws

