-- ==========================================
-- Manpage Jump System (Neovim 0.11.x)
--  - <C-]> : jump to manpage for <cword>
--  - <C-t> : jump back in man stack (per-window)
-- ==========================================

manjump = { }

-- 전역 window 단위 stack: MAN_JUMP_STACK[winid] = { buf1, buf2, ... }
_G.MAN_JUMP_STACK = _G.MAN_JUMP_STACK or {}
local STACK = _G.MAN_JUMP_STACK

----------------------------------------------------------
-- (옵션) 디버그: 현재 window 의 stack 출력
----------------------------------------------------------
local function debug_stack(prefix)
  local win = vim.api.nvim_get_current_win()
  local stack = STACK[win] or {}
  local parts = {}

  for i, buf in ipairs(stack) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then name = "[No Name]" end
    name = vim.fn.fnamemodify(name, ":t")
    table.insert(parts, string.format("%d:%s", buf, name))
  end

  vim.notify(
    string.format("%s | win=%d | stack size=%d [%s]",
      prefix, win, #stack, table.concat(parts, ", ")),
    vim.log.levels.INFO
  )
end

----------------------------------------------------------
-- helper: 현재 window 의 stack 가져오기
----------------------------------------------------------
local function get_stack_for_current_win()
  local win = vim.api.nvim_get_current_win()
  if not STACK[win] then
    STACK[win] = {}
  end
  return STACK[win], win
end

----------------------------------------------------------
-- man 페이지 존재 여부 검사
----------------------------------------------------------
local function man_exists(section, word)
  local cmd = string.format("man -w %s %s 2>/dev/null", section, word)
  local output = vim.fn.system(cmd)
  return output ~= nil and output ~= ""
end

----------------------------------------------------------
-- name(section) 형태 정규화
--   "printf(3)" → "printf", "3"
--   "printf(3).)" 같은 꼬인 패턴도 꽤 잘 처리
----------------------------------------------------------
local function normalize_word(raw)
  if not raw or raw == "" then
    return raw, nil
  end

  -- 뒤쪽 문장부호/공백 제거
  local cleaned = raw:gsub("[%s%.,;:]+$", "")

  -- 여분의 ) 정리 (ex: path_resolution(7))) → path_resolution(7)
  while cleaned:match("%)%)+$") do
    cleaned = cleaned:gsub("%)$", "", 1)
  end

  -- 가장 마지막의 (내용) 을 section 으로 인식
  local name, sec = cleaned:match("^(.-)%(([^()]+)%)$")
  if name and sec then
    return name, sec
  end

  return cleaned, nil
end

----------------------------------------------------------
-- man section 자동 탐색
----------------------------------------------------------
local function find_man_section(word)
  -- 필요하면 {2, 3, 1, 8} 등으로 늘려도 됨
  for _, sec in ipairs({ 2, 3, 1 }) do
    if man_exists(sec, word) then
      return tostring(sec)
    end
  end
  return nil
end

----------------------------------------------------------
-- man 페이지를 "완전히 새로운 버퍼"에 로드 (현재 창에서)
----------------------------------------------------------
local function open_man_in_new_buffer(section, word)
  local stack, win = get_stack_for_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  -- 현재 버퍼를 stack 에 저장
  table.insert(stack, current_buf)

  -- 기존 버퍼가 창에서 빠져도 삭제되지 않도록 보호
  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = current_buf })

  debug_stack("PUSH " .. word .. "(" .. section .. ")")

  -- manpage 불러오기
  local cmd = string.format("man %s %s | col -bx", section, word)
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #lines == 0 then
    vim.notify("Manpage not found or empty: " .. word, vim.log.levels.ERROR)
    return
  end

  -- 새 버퍼 생성 (listed = true, scratch = false)
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 버퍼 이름 설정
  local buf_name = string.format("man://%s(%s)", word, section)
  vim.api.nvim_buf_set_name(buf, buf_name)

  -- 현재 창에 새 버퍼 배치
  vim.api.nvim_win_set_buf(win, buf)

  -- manpage 버퍼 옵션
  vim.api.nvim_set_option_value("filetype",  "man",   { buf = buf })
  vim.api.nvim_set_option_value("modifiable", false,  { buf = buf })
  vim.api.nvim_set_option_value("modified",   false,  { buf = buf })
  vim.api.nvim_set_option_value("readonly",   true,   { buf = buf })
  vim.api.nvim_set_option_value("swapfile",   false,  { buf = buf })
  vim.api.nvim_set_option_value("buftype",    "nofile",{ buf = buf })
  vim.api.nvim_set_option_value("bufhidden",  "hide", { buf = buf })
end

----------------------------------------------------------
-- 메인 동작: jump to manpage for <cword>
----------------------------------------------------------
function manjump.jump()
  local raw = vim.fn.expand("<cword>")
  if not raw or raw == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end

  local word, explicit_section = normalize_word(raw)

  -- 명시적 섹션: printf(3) 같은 경우
  if explicit_section then
    if man_exists(explicit_section, word) then
      open_man_in_new_buffer(explicit_section, word)
    else
      vim.notify(
        string.format("Manpage not found: %s (%s)", word, explicit_section),
        vim.log.levels.ERROR
      )
    end
    return
  end

  -- 섹션 자동 탐색
  local sec = find_man_section(word)
  if not sec then
    vim.notify("No manpage found for: " .. word, vim.log.levels.ERROR)
    return
  end

  open_man_in_new_buffer(sec, word)
end

----------------------------------------------------------
-- 뒤로 가기: 현재 window 의 stack 에서 한 단계 pop
----------------------------------------------------------
function manjump.back()
  local stack, win = get_stack_for_current_win()

  debug_stack("POP request")

  if #stack == 0 then
    vim.notify("Manpage jump stack empty", vim.log.levels.WARN)
    return
  end

  local buf = table.remove(stack) -- 마지막 buffer 번호

  debug_stack("POP done")

  if not vim.api.nvim_buf_is_valid(buf) then
    vim.notify("Target buffer no longer exists", vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_win_set_buf(win, buf)
end

----------------------------------------------------------
-- setup: keymap 등록 (전역)
----------------------------------------------------------
function manjump.setup()
	-- NVIM 0.11 이상 체크 (선택)
	if vim.fn.has("nvim-0.11") == 0 then
		vim.notify("man-jump: Neovim 0.11+ is recommended", vim.log.levels.WARN)
	end

	-- MANPAGER 가 세팅되어 있으면, 그냥 아무것도 안 하고 종료
	if os.getenv("MANPAGER") then
		vim.notify("manjump: MANPAGER is set; manjump disabled", vim.log.levels.INFO)
		return
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "man",
		callback = function(ev)
			local opts = { buffer = ev.buf, silent = true }
			vim.keymap.set("n", "<C-]>", manjump.jump, opts)
			vim.keymap.set("n", "<C-t>", manjump.back, opts)
		end
	})
end

return manjump

