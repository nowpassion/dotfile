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
----------------------------------------------------------
-- man page 존재 여부 확인
----------------------------------------------------------
local function man_exists(section, word)
    local cmd = string.format("man -w %s %s 2>/dev/null", section, word)
    local output = vim.fn.system(cmd)
    return output ~= nil and output ~= ""
end

----------------------------------------------------------
-- manpage 문자열로 가져오기
----------------------------------------------------------
local function get_manpage(section, word)
    local cmd = string.format("MANPAGER=cat man %s %s 2>/dev/null", section, word)
    return vim.fn.systemlist(cmd)
end

----------------------------------------------------------
-- 새로운 scratch buffer 에 출력
----------------------------------------------------------
local function open_man_in_new_buffer(section, word)
    local lines = get_manpage(section, word)
    if not lines or #lines == 0 then
        vim.notify("Failed to load manpage", vim.log.levels.ERROR)
        return
    end

    -- 새 버퍼 생성
    local buf = vim.api.nvim_create_buf(true, false)
    local win = vim.api.nvim_get_current_win()

    -- 버퍼 이름 설정 (중복 방지)
    local name = string.format("man://%s(%s)", word, section)
    vim.api.nvim_buf_set_name(buf, name)

    -- 내용 삽입
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- 현재 창에 배치
    vim.api.nvim_win_set_buf(win, buf)

    -- 읽기 전용 옵션 및 하이라이트
    vim.bo[buf].buftype = ""           -- normal buffer
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
	vim.bo[buf].modified = false
    vim.bo[buf].modifiable = false     -- 읽기 전용
    vim.bo[buf].filetype = "man"       -- syntax highlight
end

----------------------------------------------------------
-- SHIFT-K 맵핑
----------------------------------------------------------
vim.keymap.set("n", "K", function()
    local word = vim.fn.expand("<cword>")
    if not word or word == "" then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
    end

    local count = vim.v.count

    -- 숫자 + K → 해당 섹션만
    if count > 0 then
        local sec = tostring(count)
        if man_exists(sec, word) then
            open_man_in_new_buffer(sec, word)
        else
            vim.notify(string.format("No manpage for '%s' in section %s", word, sec), vim.log.levels.ERROR)
        end
        return
    end

    -- K → section 2 → 3 순서 검색
    local search_order = { 2, 3 }
    for _, sec in ipairs(search_order) do
        if man_exists(sec, word) then
            open_man_in_new_buffer(sec, word)
            return
        end
    end

    vim.notify(string.format("No manpage found for '%s' in sections 2, 3", word),
               vim.log.levels.ERROR)
end, { silent = true })

-- Manpager
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
vim.api.nvim_set_keymap('n', '<F7>', ':LspClangdSwitchSourceHeader<CR>', { noremap = true })
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

-- Neogen
-- Generate comment for current line
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)

-- luasnip
local ls = require("luasnip")

--- Create a keymap that expands a snippet from vscode style snippets
--- opts = {
---     key = "<leader>c",        -- required: keymap
---     trigger = "cmm",          -- required: snippet trigger to expand
---     filetypes = {"c", "cpp"}, -- optional: restrict to these filetypes
---     mode = { "i", "n" },      -- optional: default both normal+insert
---     desc = "Expand snippet",  -- optional: description
--- }
local function create_snippet_keymap(opts)
	vim.keymap.set(opts.mode or { "n", "i" }, opts.key, function()
		local ft = vim.bo.filetype

		-- If filetypes are specified, ensure current ft is allowed
		if opts.filetypes and not vim.tbl_contains(opts.filetypes, ft) then
			print("Snippet not available for filetype: " .. ft)
			return
		end

		-- Load snippets for this filetype
		local snippets = ls.get_snippets(ft)

		-- Find the target snippet by trigger
		for _, snip in ipairs(snippets or {}) do
			if snip.trigger == opts.trigger then
				ls.snip_expand(snip)
				return
			end
		end

		print("Snippet '" .. opts.trigger .. "' not found for filetype: " .. ft)
	end, { desc = opts.desc or ("Expand snippet: " .. opts.trigger) })
end

-- np (nowpassion) custom snippets
-- CHECK ~/.config/nvim/snippets 
local mappings = {
	{
		key = "<Leader>ncm",
		trigger = "np_custom_mcomment",
		filetypes = { "c", "cpp", "h" },
		desc = "Insert C multi-line comment block",
	},
	{
		key = "<Leader>ncs",
		trigger = "np_custom_switchcase",
		filetypes = { "c", "cpp" },
		desc = "Insert switch/case",
	},
}

for _, m in ipairs(mappings) do
    create_snippet_keymap(m)
end

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
