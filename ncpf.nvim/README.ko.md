# NCPF 플러그인 추출 작업 완료

## 작업 요약

dotfile 리파지토리에 있던 ncpf (Neovim C Project File) 기능을 별도의 독립 실행형 Neovim 플러그인으로 배포할 수 있도록 작업을 완료했습니다.

## 완료된 작업

### 1. 플러그인 구조 생성 ✅
- `ncpf.nvim/` 디렉토리에 표준 Neovim 플러그인 구조 생성
- 모든 주요 플러그인 매니저와 호환 (lazy.nvim, packer.nvim, vim-plug)

### 2. 핵심 코드 이전 ✅
- `nvim/lua/ncpf/ncpf.lua` → `ncpf.nvim/lua/ncpf/ncpf.lua`
- `nvim/lua/ncpf/ncpf_lib.lua` → `ncpf.nvim/lua/ncpf/ncpf_lib.lua`
- `nvim/plugin/ncpf/init.lua` → `ncpf.nvim/plugin/ncpf.lua` (개선됨)

### 3. 플러그인 초기화 개선 ✅
- C/C++ 파일 열 때 자동으로 초기화되는 autocommand 추가
- 세션당 한 번만 초기화되도록 최적화

### 4. 문서화 작성 ✅

생성된 문서들:

| 파일 | 설명 |
|------|------|
| `README.md` | 플러그인 주요 문서 (영문) |
| `QUICKSTART.md` | 5분 만에 시작하는 가이드 |
| `MIGRATION.md` | 기존 사용자를 위한 마이그레이션 가이드 |
| `DISTRIBUTION.md` | 플러그인 배포 방법 가이드 |
| `CONTRIBUTING.md` | 기여 가이드라인 |
| `CHANGELOG.md` | 버전 히스토리 |
| `LICENSE` | MIT 라이센스 |
| `doc/ncpf.txt` | Vim 헬프 문서 (`:help ncpf`) |
| `examples/README.md` | 다양한 사용 예제 |

### 5. 검증 도구 추가 ✅
- `test-structure.sh`: 플러그인 구조 검증 스크립트
- 모든 필수 파일과 디렉토리 확인
- Lua 모듈 구조 검증

## 플러그인 기능

### 주요 기능
- ✨ C/C++ 프로젝트 자동 인식
- 🚀 여러 코드 탐색 도구 지원:
  - clangd (LSP, 권장)
  - coc.nvim + ccls
  - cscope
  - ctags
- ⚙️ 유연한 설정 옵션
- 🎯 자동 키 매핑 설정

### 지원 파일 타입
- `.c`, `.cpp`, `.cc`, `.h`, `.hpp`

### 키 바인딩
- `<C-]>`: 정의로 이동
- `<C-\>`: 참조 찾기

## 사용 방법

### 설치 (lazy.nvim)

```lua
{
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

### 프로젝트 설정

```bash
# 프로젝트 루트에 마커 파일 생성
touch .nvim_c_project_root

# compile_commands.json 생성 (CMake)
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .

# 또는 Makefile 프로젝트 (Bear 사용)
bear -- make
```

## 다음 단계

### 독립 리파지토리로 배포하기

1. **GitHub에 새 리파지토리 생성**
   ```bash
   # GitHub에서 새 리파지토리 생성: ncpf.nvim
   ```

2. **플러그인 코드 복사 및 푸시**
   ```bash
   # 새 디렉토리 생성
   mkdir ncpf.nvim-standalone
   cd ncpf.nvim-standalone
   
   # Git 초기화
   git init
   
   # ncpf.nvim 디렉토리의 모든 파일 복사
   cp -r /path/to/dotfile/ncpf.nvim/* .
   
   # 커밋 및 푸시
   git add .
   git commit -m "Initial commit: ncpf.nvim plugin"
   git remote add origin https://github.com/nowpassion/ncpf.nvim.git
   git branch -M main
   git push -u origin main
   ```

3. **첫 번째 릴리스 태그**
   ```bash
   git tag -a v1.0.0 -m "Initial release: v1.0.0"
   git push origin v1.0.0
   ```

### 대안: 이 리파지토리에서 직접 사용

별도 리파지토리를 만들지 않고 이 dotfile 리파지토리에서 직접 사용할 수도 있습니다:

```lua
{
  'nowpassion/dotfile',
  config = function()
    vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/dotfile/ncpf.nvim')
    require('ncpf.ncpf').init()
  end,
}
```

하지만 독립 리파지토리를 만드는 것을 권장합니다.

## 디렉토리 구조

```
ncpf.nvim/
├── plugin/              # 자동 로드되는 플러그인 코드
│   └── ncpf.lua
├── lua/                 # Lua 모듈
│   └── ncpf/
│       ├── ncpf.lua
│       └── ncpf_lib.lua
├── doc/                 # Vim 헬프 문서
│   └── ncpf.txt
├── examples/            # 사용 예제
│   └── README.md
├── README.md            # 메인 문서
├── QUICKSTART.md        # 빠른 시작 가이드
├── MIGRATION.md         # 마이그레이션 가이드
├── DISTRIBUTION.md      # 배포 가이드
├── CONTRIBUTING.md      # 기여 가이드
├── CHANGELOG.md         # 변경 이력
├── LICENSE              # MIT 라이센스
└── test-structure.sh    # 구조 검증 스크립트
```

## 테스트

구조 검증 테스트 실행:

```bash
cd ncpf.nvim
./test-structure.sh
```

모든 검증이 통과했습니다! ✅

## 참고 문서

- **빠른 시작**: `ncpf.nvim/QUICKSTART.md`
- **전체 문서**: `ncpf.nvim/README.md`
- **배포 가이드**: `ncpf.nvim/DISTRIBUTION.md`
- **마이그레이션**: `ncpf.nvim/MIGRATION.md`
- **사용 예제**: `ncpf.nvim/examples/README.md`
- **Vim 헬프**: Neovim에서 `:help ncpf` 실행

## 라이센스

MIT License - 자유롭게 사용, 수정, 배포 가능

## 문의

이슈나 질문이 있으면:
- GitHub Issues: https://github.com/nowpassion/ncpf.nvim/issues (배포 후)
- 또는 이 dotfile 리파지토리의 Issues

---

작성일: 2026-02-13
작업자: GitHub Copilot
