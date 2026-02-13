# NCPF Repository Creation Guide

이 디렉토리에는 ncpf.nvim을 별도의 리파지토리로 분리하기 위한 자동화 스크립트가 있습니다.

This directory contains automation scripts to separate ncpf.nvim into a standalone repository.

## 스크립트 / Scripts

### 1. create-ncpf-repo.sh (추천 / Recommended)

**간단한 방법**: ncpf.nvim 디렉토리를 새 리파지토리로 복사합니다.

**Simple method**: Copies the ncpf.nvim directory to a new repository.

```bash
./create-ncpf-repo.sh
```

**장점 (Pros)**:
- ✅ 빠르고 간단함 (Fast and simple)
- ✅ 깨끗한 git 히스토리 (Clean git history)
- ✅ 신뢰성 높음 (More reliable)

**단점 (Cons)**:
- ❌ git 히스토리가 보존되지 않음 (Git history not preserved)

### 2. create-ncpf-repo-with-history.sh (고급 / Advanced)

**고급 방법**: git filter-branch를 사용하여 ncpf.nvim 관련 커밋 히스토리를 보존합니다.

**Advanced method**: Preserves git history of ncpf.nvim-related commits using git filter-branch.

```bash
./create-ncpf-repo-with-history.sh
```

**장점 (Pros)**:
- ✅ git 히스토리 보존 (Preserves git history)
- ✅ 기여자 정보 유지 (Maintains contributor information)

**단점 (Cons)**:
- ❌ 느림 (Slower)
- ❌ 더 복잡함 (More complex)

## 사용 방법 / Usage

### 단계 1: 스크립트 실행 (Run Script)

원하는 스크립트를 선택하여 실행:

Choose and run your preferred script:

```bash
# Option 1: Simple method (recommended)
./create-ncpf-repo.sh

# OR

# Option 2: With git history
./create-ncpf-repo-with-history.sh
```

### 단계 2: GitHub에 리파지토리 생성 (Create GitHub Repository)

1. https://github.com/new 로 이동
2. 설정:
   - **Repository name**: `ncpf`
   - **Description**: `Neovim C Project File - Automatic C/C++ project configuration`
   - **Public** 선택
   - ⚠️ **Do NOT** initialize with README, .gitignore, or license

### 단계 3: 푸시 (Push to GitHub)

```bash
cd ../ncpf
git remote add origin https://github.com/nowpassion/ncpf.git
git push -u origin main
git push origin v1.0.0
```

### 단계 4: GitHub 설정 (GitHub Settings)

리파지토리 페이지에서:

On the repository page:

1. **About** 섹션에서 ⚙️ 클릭
2. **Topics** 추가:
   - `neovim`
   - `neovim-plugin`
   - `c`
   - `cpp`
   - `lsp`
   - `clangd`
   - `cscope`

## 수동 방법 / Manual Method

스크립트를 사용하지 않으려면 `ncpf.nvim/DISTRIBUTION.md`의 지침을 따르세요.

If you prefer not to use scripts, follow the instructions in `ncpf.nvim/DISTRIBUTION.md`.

## 문제 해결 / Troubleshooting

### "Permission denied" 오류

```bash
chmod +x create-ncpf-repo.sh
chmod +x create-ncpf-repo-with-history.sh
```

### 이미 존재하는 디렉토리

스크립트가 자동으로 물어봅니다. 'y'를 입력하여 제거하고 계속하세요.

The script will automatically ask. Type 'y' to remove and continue.

### Git filter-repo not found

두 번째 스크립트는 자동으로 filter-branch로 fallback됩니다.

The second script automatically falls back to filter-branch.

## 다음 단계 / Next Steps

리파지토리가 생성되면:

After the repository is created:

1. 📢 커뮤니티 공유 (Share with community)
   - [awesome-neovim](https://github.com/rockerBOO/awesome-neovim)에 PR
   - Reddit r/neovim
   - Discord servers

2. 📝 문서 업데이트 (Update documentation)
   - README.md에 설치 URL 확인
   - 예제 코드 테스트

3. 🏷️ 릴리스 관리 (Manage releases)
   - GitHub Releases 페이지 업데이트
   - 변경 사항은 CHANGELOG.md에 기록

---

**도움이 필요하신가요?** GitHub Issues를 열어주세요!

**Need help?** Open a GitHub Issue!
