local ncpf_lib = {

}

local function cscope_check(path)
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

local function ctags_check(path)
	local ret = 0
	local ctags_path = path .. '/tags'

	if vim.fn.filereadable(ctags_path) == 0 then
		return ret
	end

	vim.o.tags = ctags_path
	ret = 1

	return ret
end

local function lsp_clangd_check(path)
	local ret = 0
	local clangd_path = path .. '/.cache/clangd'

	if vim.fn.isdirectory(clangd_path) == 0 then
		return ret
	end

	vim.api.nvim_set_keymap('n', '<C-\\>', ':Telescope lsp_references<CR><CR>', { noremap = true })
	vim.api.nvim_set_keymap('n', '<C-]>', ':Telescope lsp_definitions<CR><CR>', { noremap = true })

	ret = 1
	return ret
end

local function lsp_coc_ccls_check(path)
	local ret = 0
	local ccls_path = path .. '/.ccls-cache'
	local coc_loaded = vim.g.coc_loaded

	if coc_loaded == 0 or vim.fn.isdirectory(ccls_path) == 0 then
		return ret
	end

	vim.api.nvim_set_keymap('n', '<C-\\>', '<Plug>(coc-references)', {})
	vim.cmd('set tagfunc=CocTagFunc')

	ret = 1
	return ret
end

local codedb_funcs = {
	cscope_check,
	ctags_check,
	lsp_clangd_check,
	lsp_coc_ccls_check,
}

local function read_tags_project_root(path)
	local ret = 0;
	for k, v in pairs(codedb_funcs) do
		ret = v(path)
		if ret == 1 then
			break
		end
	end
end

-- clangd driver
local ncpf_clangd_arg = { }
local ncpf_clangd_cmd = { }
local ncpf_clangd_cmd_postfix = { }

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

local function setup_npf(clangd_opt)
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

	if is_empty(clangd_opt.compile_commands_dir) == false then
		table.insert(ncpf_clangd_cmd, clangd_opt.compile_commands_dir)
	end

	if is_empty(clangd_opt.query_driver) == false then
		table.insert(ncpf_clangd_cmd, clangd_opt.query_driver)
	end

	table_concat(ncpf_clangd_cmd, ncpf_clangd_cmd_postfix)
end

local function ncpf_setup_clangd(clangd_opt)
	setup_npf(clangd_opt)
end

ncpf_lib.get_clangd_cmd = function()
	return ncpf_clangd_cmd
end

local function ncpf_cland_conf_read(path)
	local file_path = path .. '/.ncpf_clangd_option'

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
end

-- FIND ProjectRoot!!
local ncpf_filename = ''
local ncpf_clangd_root_dir = ''
local ncpf_top_dir = ''

local function Find_project_root(path)
	local ncpf_file = path .. '/' .. ncpf_filename
	local from_source_dir = string.find(path, ncpf_clangd_root_dir)

	if vim.fn.filereadable(ncpf_file) == 1 then
		read_tags_project_root(path)
		ncpf_cland_conf_read(path)
		ncpf_setup_clangd(ncpf_clangd_arg)
		ncpf_clangd_root_dir = path
		return 1
	end

	-- 재귀적 호출에 의해 최상단까지 파일을 못찾은 경우 
	if path == '/' then
		print('[ERROR] => Not found nvim project file (/)')
		return 0
	end

	-- 재귀적 호출에 의해 정의된 프로젝트 최상단까지 파일을 못찾은 경우 
	if path == ncpf_top_dir then
		print('[ERROR] => Not found nvim project file')
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

local loaded_ncpf = 0
local ncpf_filename_opt = ''

local function init_nvim_project_root()
	-- Check NPF plugin is already loaded
	if loaded_ncpf == 1 then
		return
	end

	if not ncpf_top_dir or #ncpf_top_dir < 1 then
		ncpf_top_dir = vim.env.HOME
	end

	if not ncpf_filename_opt or #ncpf_filename_opt < 1 then
		ncpf_filename = '.nvim_c_project_root'
	end

	loaded_ncpf = 1
	local cwd = vim.fn.getcwd()

	if Find_project_root(cwd) == 0 then
		print('[NOTICE] => read code db from current directory.')
		read_tags_project_root(cwd)
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
		["%.asm$"] = function()
			init_nvim_project_root()
		end,
		["%.hpp$"] = function()
			init_nvim_project_root()
		end,
		["%.cc$"] = function()
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
	ncpf_filename_opt = root_marker_file

	set_filetype_settings(vim.fn.expand('%'))
end

return ncpf_lib
