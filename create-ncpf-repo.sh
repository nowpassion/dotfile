#!/bin/bash
# Script to create a separate ncpf repository from the ncpf.nvim directory
# This script helps automate the process described in DISTRIBUTION.md

set -e

echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║          NCPF Repository Creation Script                            ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

# Configuration
REPO_NAME="ncpf"
TARGET_DIR="../${REPO_NAME}"
SOURCE_DIR="./ncpf.nvim"

# Check if we're in the dotfile repository
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: ncpf.nvim directory not found!"
    echo "   Please run this script from the dotfile repository root."
    exit 1
fi

echo "📋 Configuration:"
echo "   Repository name: $REPO_NAME"
echo "   Source directory: $SOURCE_DIR"
echo "   Target directory: $TARGET_DIR"
echo ""

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
    echo "   ✓ Removed existing directory"
fi

# Create target directory
echo ""
echo "📁 Creating new repository directory..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Initialize git
echo "🔧 Initializing Git repository..."
git init
git branch -M main

# Copy all files from ncpf.nvim
echo "📦 Copying plugin files..."
cp -r ../dotfile/ncpf.nvim/* .

# Remove .gitignore from ncpf.nvim if it exists (we'll use repo-wide one)
if [ -f ".gitignore" ]; then
    echo "   ✓ Using existing .gitignore from plugin"
fi

# Create initial commit
echo "💾 Creating initial commit..."
git add .
git commit -m "Initial commit: ncpf.nvim plugin v1.0.0

Extracted from nowpassion/dotfile repository.

Features:
- Automatic C/C++ project root detection
- Support for multiple code navigation tools (clangd, cscope, ctags, ccls)
- Flexible configuration options
- Automatic key mapping setup
- Comprehensive documentation in English and Korean"

echo ""
echo "✅ Repository created successfully!"
echo ""
echo "📍 Location: $TARGET_DIR"
echo ""
echo "🚀 Next steps:"
echo ""
echo "1. Create the repository on GitHub:"
echo "   → Go to https://github.com/new"
echo "   → Repository name: ncpf"
echo "   → Description: Neovim C Project File - Automatic C/C++ project configuration"
echo "   → Public repository"
echo "   → Do NOT initialize with README, .gitignore, or license (we already have them)"
echo ""
echo "2. Push to GitHub:"
echo "   cd $TARGET_DIR"
echo "   git remote add origin https://github.com/nowpassion/ncpf.git"
echo "   git push -u origin main"
echo ""
echo "3. Create the first release:"
echo "   git tag -a v1.0.0 -m 'Initial release: v1.0.0'"
echo "   git push origin v1.0.0"
echo ""
echo "4. (Optional) Add topics on GitHub:"
echo "   → neovim, neovim-plugin, c, cpp, lsp, clangd, cscope"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
