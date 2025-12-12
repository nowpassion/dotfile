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
function keymap_fn_man_open()
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
end

--
-- Convert comment stype
--

-- CPP comment to C comment style
function cpp_comment_to_c_comment()
  local buf = 0
  local mode = vim.fn.mode()

  ------------------------------------------------------------------
  -- 0. 변환 기준 줄과 범위 결정
  ------------------------------------------------------------------
  local start, bottom

  if mode == "v" or mode == "V" or mode == "\22" then
    local l1 = vim.fn.line("'<")
    local l2 = vim.fn.line("'>")
    start  = math.min(l1, l2) - 1 -- 0-based
    bottom = math.max(l1, l2)     -- 1-based
  else
    start  = vim.api.nvim_win_get_cursor(0)[1] - 1
    bottom = vim.api.nvim_buf_line_count(buf)
  end

  ------------------------------------------------------------------
  -- 1. 선택 범위 정확히 읽기
  ------------------------------------------------------------------
  local lines = vim.api.nvim_buf_get_lines(buf, start, bottom, false)
  if #lines == 0 then return end

  ------------------------------------------------------------------
  -- 2. 시작 줄이 // 인지 확인
  ------------------------------------------------------------------
  local indent = lines[1]:match("^(%s*)//")
  if not indent then return end

  ------------------------------------------------------------------
  -- 3. 선택 범위 내에서 연속된 // 끝 찾기
  ------------------------------------------------------------------
  local end_idx = 1
  for i = 2, #lines do
    if lines[i]:match("^%s*//") then
      end_idx = i
    else
      break
    end
  end

  ------------------------------------------------------------------
  -- 4. 아래쪽 비어 있는 // 제거
  ------------------------------------------------------------------
  local last_content_idx = end_idx
  while last_content_idx >= 1 do
    local content = lines[last_content_idx]:gsub("^%s*//%s?", "")
    if content == "" then
      last_content_idx = last_content_idx - 1
    else
      break
    end
  end
  if last_content_idx < 1 then return end

  ------------------------------------------------------------------
  -- 5. C 스타일 주석 생성
  ------------------------------------------------------------------
  local new_lines = {}
  table.insert(new_lines, indent .. "/**")

  for i = 1, last_content_idx do
    local content = lines[i]:gsub("^%s*//%s?", "")
    table.insert(new_lines, indent .. " * " .. content)
  end

  table.insert(new_lines, indent .. " **/")

  ------------------------------------------------------------------
  -- 6. 정확히 같은 범위만 치환
  ------------------------------------------------------------------
  vim.api.nvim_buf_set_lines(
    buf,
    start,
    start + end_idx,
    false,
    new_lines
  )

  ------------------------------------------------------------------
  -- 7. 커서 이동
  ------------------------------------------------------------------
  vim.api.nvim_win_set_cursor(0, { start + 1, #indent })

  ------------------------------------------------------------------
  -- 8. Normal 모드로 복귀
  ------------------------------------------------------------------
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "n",
    true
  )
end

-- C comment to CPP comment style
function c_comment_to_cpp_comment()
  local buf = 0
  local mode = vim.fn.mode()

  ------------------------------------------------------------------
  -- 0. 시작 줄 / 범위 결정
  ------------------------------------------------------------------
  local start, bottom

  if mode == "v" or mode == "V" or mode == "\22" then
    local l1 = vim.fn.line("'<")
    local l2 = vim.fn.line("'>")
    start  = math.min(l1, l2) - 1 -- 0-based
    bottom = math.max(l1, l2)     -- 1-based (exclusive later)
  else
    start  = vim.api.nvim_win_get_cursor(0)[1] - 1
    bottom = vim.api.nvim_buf_line_count(buf)
  end

  ------------------------------------------------------------------
  -- 1. 선택 범위 정확히 읽기
  ------------------------------------------------------------------
  local lines = vim.api.nvim_buf_get_lines(buf, start, bottom, false)
  if #lines < 2 then return end

  ------------------------------------------------------------------
  -- 2. 시작 줄 검사: /*, /**, /**** ...
  ------------------------------------------------------------------
  if not lines[1]:match("^%s*/%*+") then return end
  local indent = lines[1]:match("^(%s*)") or ""

  ------------------------------------------------------------------
  -- 3. 종료 줄 찾기: */, **/, ****/ ...
  ------------------------------------------------------------------
  local end_idx
  for i = 2, #lines do
    if lines[i]:match("^%s*%*+/") then
      end_idx = i
      break
    end
  end
  if not end_idx then return end

  ------------------------------------------------------------------
  -- 4. 아래쪽 장식용 '*' 줄 제거
  ------------------------------------------------------------------
  local last_content_idx = end_idx - 1
  while last_content_idx >= 2 do
    if lines[last_content_idx]:match("^%s*%*+%s*$") then
      last_content_idx = last_content_idx - 1
    else
      break
    end
  end
  if last_content_idx < 2 then return end

  ------------------------------------------------------------------
  -- 5. C++ 스타일 주석 생성
  ------------------------------------------------------------------
  local new_lines = {}

  for i = 2, last_content_idx do
    local content = lines[i]
      :gsub("^%s*%*+%s?", "")
      :gsub("^%s*", "")

    table.insert(new_lines, indent .. "//" .. (content ~= "" and " " .. content or ""))
  end

  ------------------------------------------------------------------
  -- 6. 정확히 해당 블록만 치환
  ------------------------------------------------------------------
  vim.api.nvim_buf_set_lines(
    buf,
    start,
    start + end_idx,
    false,
    new_lines
  )

  ------------------------------------------------------------------
  -- 7. 커서 이동: 첫 // 줄의 첫 문자
  ------------------------------------------------------------------
  vim.api.nvim_win_set_cursor(0, {
    start + 1,
    #indent
  })

  ------------------------------------------------------------------
  -- 8. Normal 모드 복귀
  ------------------------------------------------------------------
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "n",
    true
  )
end

