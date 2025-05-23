local ncpf_lib = {

}

-- util functions
local function is_empty(s)
	if s == '' or s == nil then
		return true
	end

	return false
end

local function table_concat(table1, table2)
	for _, value in ipairs(table2) do
		table.insert(table1, value)
	end
end

-- define a function to spring a string with give separator
local function strsplit(inputstr, sep)
	-- define an array
	local t = { }

	-- if sep is null, set it as space
	if sep == nil then
		sep = '%s'
	end

	-- split string based on sep
	for str in string.gmatch(inputstr, '([^'..sep..']+)') do
		-- insert the substring in table
		table.insert(t, str)
	end

	-- return the array
	return t
end

local function strsplit_idx_get(inputstr, sep, idx)
	local t = { }
	local str
	local i = 1

	t = strsplit(inputstr, sep);

	for _,v in ipairs(t) do
		if i == idx then
			str = v
			break
		end

		i = i + 1
	end

	return str
end

-- cscope
local function cscope_setup(path)
	local ret = 0
	local cscope_path = path .. '/cscope.out'

	if vim.fn.filereadable(cscope_path) == 0 then
		return ret
	end

	-- Cscope Wrapper
	local cws_setup = require('cws').setup
	if cws_setup and type(cws_setup) == "function" then
		cws_setup(cscope_path)
		vim.api.nvim_set_keymap('n', '<C-\\>', ':Cscope find c <C-R>=expand("<cword>")<CR><CR>', { noremap = true })
		vim.api.nvim_set_keymap('n', '<C-]>', ':Cstag <C-R>=expand("<cword>")<CR><CR>', { noremap = true })
		ret = 1
	end

	return ret
end

-- ctags
local function ctags_setup(path)
	local ctags_path = path .. '/tags'

	if vim.fn.filereadable(ctags_path) == 0 then
		return 0
	end

	vim.o.tags = ctags_path

	return 1
end

-- lspconfig + clangd
local function ncpf_clangd_conf_read(path)
	local file_path = path .. '/.ncpf_clangd_option'
	local ncpf_clangd_arg = { }

	if vim.fn.filereadable(file_path) == 1 then
		local lines = vim.fn.readfile(file_path)
		for _, line in ipairs(lines) do
			if string.find(line, "compile%-commands%-dir") then
				ncpf_clangd_arg.compile_commands_dir = line
			end

			if string.find(line, "query%-driver") then
				ncpf_clangd_arg.query_driver = line
			end
		end

	end

	return ncpf_clangd_arg
end

local function setup_clangd_cmd(ncpf_clangd_arg)
	local ncpf_clangd_cmd = { }
	local ncpf_clangd_cmd_postfix = { }

	ncpf_clangd_cmd = {
		"clangd",
		"--background-index",
		"--malloc-trim",
	}

	ncpf_clangd_cmd_postfix = {
		"--enable-config",
		"--header-insertion=never",
		"--completion-style=detailed"
	}

	if is_empty(ncpf_clangd_arg.compile_commands_dir) == false then
		table.insert(ncpf_clangd_cmd, ncpf_clangd_arg.compile_commands_dir)
	end

	if is_empty(ncpf_clangd_arg.query_driver) == false then
		table.insert(ncpf_clangd_cmd, ncpf_clangd_arg.query_driver)
	end

	table_concat(ncpf_clangd_cmd, ncpf_clangd_cmd_postfix)

	return ncpf_clangd_cmd
end

local function lsp_clangd_setup(path)
	local compiledb_path = ''
	local clangd_arg = { }
	local clangd_cmd = { }
	local capabilities

	clangd_arg = ncpf_clangd_conf_read(path)

	if is_empty(clangd_arg.compile_commands_dir) == false then
		compiledb_path = strsplit_idx_get(clangd_arg.compile_commands_dir, '=', 2)
	else
		compiledb_path = path
		clangd_arg.compile_commands_dir= '--compile-commands-dir=' .. compiledb_path
	end

	compiledb_path = compiledb_path .. '/compile_commands.json'
	if vim.fn.filereadable(compiledb_path) == 0 then
		print('[ERROR] => compiledb_path is not exist', compiledb_path)
		return 0
	end

	capabilities = require('cmp_nvim_lsp').default_capabilities()
	clangd_cmd = setup_clangd_cmd(clangd_arg)

	vim.api.nvim_set_keymap('n', '<C-\\>', ':Telescope lsp_references<CR><CR>', { noremap = true })
	vim.api.nvim_set_keymap('n', '<C-]>', ':Telescope lsp_definitions<CR><CR>', { noremap = true })

	vim.lsp.enable('clangd')
	vim.lsp.config('clangd', {
		capabilities = capabilities,
		cmd = clangd_cmd
	})

	return 1
end

-- coc + ccls
-- TODO : setup coc + ccls lsp
local function lsp_coc_ccls_setup(path)
	local compiledb_path = path .. '/compile_commands.json'
	local ccls_path = path .. '/.ccls-cache'
	local coc_loaded = vim.g.coc_loaded

	if coc_loaded == 0 or vim.fn.isdirectory(ccls_path) == 0 then
		return 0
	end

	vim.api.nvim_set_keymap('n', '<C-\\>', '<Plug>(coc-references)', {})
	vim.cmd('set tagfunc=CocTagFunc')

	return 1
end

-- Setup Code DB
local codedb_funcs = {
	lsp_clangd_setup,
	lsp_coc_ccls_setup,
	cscope_setup,
	ctags_setup,
}

local function codedb_setup(path)
	local ret = 0;

	for _, v in pairs(codedb_funcs) do
		ret = v(path)
		if ret == 1 then
			break
		end
	end

	return ret
end

-- FIND ProjectRoot!!
local ncpf_root_marker = ''
local ncpf_root_dir = ''
local ncpf_top_dir = ''
local loaded_ncpf = 0

local function Find_project_root(path)
	local ncpf_file = path .. '/' .. ncpf_root_marker
	local from_source_dir = string.find(path, ncpf_root_dir)

	if vim.fn.filereadable(ncpf_file) == 1 then
		ncpf_root_dir = path
		return codedb_setup(path)
	end

	-- 재귀적 호출에 의해 최상단까지 파일을 못찾은 경우 
	if path == '/' then
		print('[ERROR] => Not found nvim c project file (/)')
		return 0
	end

	-- 재귀적 호출에 의해 정의된 프로젝트 최상단까지 파일을 못찾은 경우 
	if path == ncpf_top_dir then
		print('[ERROR] => Not found nvim c project file (top dir)', ncpf_top_dir)
		return 0
	end

	-- 프로젝트 루트 검색 디렉토리에 포함되어 있지 않으면 종료
	if from_source_dir == nil then
		print('[ERROR] => Only work on source directory')
		return 0
	end

	local ncpf_path = path .. "/.."
	Find_project_root(vim.fn.resolve(vim.fn.expand(ncpf_path)))
end

local function init_nvim_project_root()
	-- Check NPF plugin is already loaded
	if loaded_ncpf == 1 then
		return
	end

	if is_empty(ncpf_top_dir) then
		ncpf_top_dir = vim.env.HOME
	end

	if is_empty(ncpf_root_marker) then
		ncpf_root_marker = '.nvim_c_project_root'
	end

	loaded_ncpf = 1
	local cwd = vim.fn.getcwd()

	if Find_project_root(cwd) == 0 then
		print('[NOTICE] => read code db from current directory.')
		-- TOOO : error process ??
	end
end

-- 파일 이름 패턴에 따른 설정 함수
local function set_filetype_settings(filename)
	local patterns = {
		["%.c$"] = function()
			init_nvim_project_root()
		end,
		["%.h$"] = function()
			init_nvim_project_root()
		end,
		["%.hpp$"] = function()
			init_nvim_project_root()
		end,
		["%.cc$"] = function()
			init_nvim_project_root()
		end,
		["%.cpp$"] = function()
			init_nvim_project_root()
		end,

		-- 여기 다른 파일 이름 패턴에 대한 설정 추가
	}

	for pattern, func in pairs(patterns) do
		if filename:match(pattern) then
			func()
			return
		end
	end
end

-- autocmd는 실제 파일이 로딩될 때 불리기 때문에 먼저 처리해야 할 일이 있으면 별도로 처리해야 한다.
ncpf_lib.ncpf_setup = function(top_dir, root_marker_file)
	ncpf_top_dir = top_dir
	ncpf_root_marker = root_marker_file
	set_filetype_settings(vim.fn.expand('%'))
end

ncpf_lib.unset_ncpf = function()
	loaded_ncpf = 1
end

return ncpf_lib
