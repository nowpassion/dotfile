#!/bin/bash
# Advanced script to create ncpf repository using git filter-branch
# This preserves the git history related to the ncpf.nvim directory

set -e

echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║     NCPF Repository Creation (with Git History)                     ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

# Configuration
REPO_NAME="ncpf"
TARGET_DIR="../${REPO_NAME}"
BRANCH_NAME="copilot/add-ncpf-neovim-plugin"

echo "📋 This script will:"
echo "   1. Clone the dotfile repository to a new location"
echo "   2. Extract only the ncpf.nvim directory with its git history"
echo "   3. Move ncpf.nvim contents to repository root"
echo "   4. Clean up the git history"
echo ""
echo "⚠️  This process takes a few minutes..."
echo ""

read -p "Continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted."
    exit 1
fi

# Check if target directory already exists
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: Target directory $TARGET_DIR already exists!"
    read -p "   Do you want to remove it and continue? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted."
        exit 1
    fi
    rm -rf "$TARGET_DIR"
fi

echo ""
echo "📁 Step 1: Cloning repository..."
git clone . "$TARGET_DIR"
cd "$TARGET_DIR"

echo ""
echo "🌿 Step 2: Checking out the ncpf branch..."
git checkout "$BRANCH_NAME"

echo ""
echo "🔧 Step 3: Extracting ncpf.nvim directory history..."
# Use git filter-repo if available, otherwise use filter-branch
if command -v git-filter-repo &> /dev/null; then
    echo "   Using git-filter-repo (recommended)..."
    git filter-repo --path ncpf.nvim/ --path-rename ncpf.nvim/:
else
    echo "   Using git filter-branch (legacy method)..."
    git filter-branch --prune-empty --subdirectory-filter ncpf.nvim "$BRANCH_NAME"
fi

echo ""
echo "🧹 Step 4: Cleaning up..."
git checkout -b main
git branch -D "$BRANCH_NAME" 2>/dev/null || true
git remote remove origin

echo ""
echo "📝 Step 5: Creating release commit..."
git tag -a v1.0.0 -m "Initial release: ncpf.nvim v1.0.0

Neovim C Project File - Automatic C/C++ project configuration

Features:
- Automatic C/C++ project root detection
- Support for multiple code navigation tools (clangd, cscope, ctags, ccls)
- Flexible configuration options
- Automatic key mapping setup
- Comprehensive documentation in English and Korean

Extracted from nowpassion/dotfile repository."

echo ""
echo "✅ Repository created successfully with git history!"
echo ""
echo "📍 Location: $TARGET_DIR"
echo ""
echo "📊 Statistics:"
cd "$TARGET_DIR"
echo "   Files: $(git ls-files | wc -l)"
echo "   Commits: $(git rev-list --count HEAD)"
echo "   Size: $(du -sh . | cut -f1)"
echo ""
echo "🚀 Next steps:"
echo ""
echo "1. Create the repository on GitHub:"
echo "   → Go to https://github.com/new"
echo "   → Repository name: ncpf"
echo "   → Description: Neovim C Project File - Automatic C/C++ project configuration"
echo "   → Public repository"
echo "   → Do NOT initialize with README, .gitignore, or license"
echo ""
echo "2. Push to GitHub:"
echo "   cd $TARGET_DIR"
echo "   git remote add origin https://github.com/nowpassion/ncpf.git"
echo "   git push -u origin main"
echo "   git push origin v1.0.0"
echo ""
echo "3. Update repository settings on GitHub:"
echo "   → Add topics: neovim, neovim-plugin, c, cpp, lsp, clangd"
echo "   → Add description from README.md"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
