#!/bin/bash
# Quick test script for ncpf.nvim plugin structure

echo "=== NCPF.NVIM Plugin Structure Test ==="
echo ""

# Check directory structure
echo "✓ Checking directory structure..."
REQUIRED_DIRS=("lua/ncpf" "plugin" "doc" "examples")
for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "  ✓ $dir/ exists"
  else
    echo "  ✗ $dir/ missing"
    exit 1
  fi
done
echo ""

# Check required files
echo "✓ Checking required files..."
REQUIRED_FILES=(
  "README.md"
  "LICENSE"
  "CHANGELOG.md"
  "lua/ncpf/ncpf.lua"
  "lua/ncpf/ncpf_lib.lua"
  "plugin/ncpf.lua"
  "doc/ncpf.txt"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "  ✓ $file exists"
  else
    echo "  ✗ $file missing"
    exit 1
  fi
done
echo ""

# Check Lua syntax if luac is available
if command -v luac &> /dev/null; then
  echo "✓ Checking Lua syntax..."
  for luafile in lua/ncpf/*.lua plugin/*.lua; do
    if luac -p "$luafile" 2>/dev/null; then
      echo "  ✓ $luafile syntax OK"
    else
      echo "  ✗ $luafile syntax error"
      exit 1
    fi
  done
  echo ""
else
  echo "⚠ luac not found, skipping syntax check"
  echo ""
fi

# Check module structure
echo "✓ Checking module structure..."
if grep -q "return ncpf" lua/ncpf/ncpf.lua; then
  echo "  ✓ ncpf.lua returns module"
else
  echo "  ✗ ncpf.lua doesn't return module"
  exit 1
fi

if grep -q "return ncpf_lib" lua/ncpf/ncpf_lib.lua; then
  echo "  ✓ ncpf_lib.lua returns module"
else
  echo "  ✗ ncpf_lib.lua doesn't return module"
  exit 1
fi
echo ""

# Check documentation
echo "✓ Checking documentation..."
if grep -q "ncpf.nvim" README.md; then
  echo "  ✓ README.md contains plugin name"
else
  echo "  ✗ README.md missing plugin name"
  exit 1
fi

if grep -q "*ncpf.txt*" doc/ncpf.txt; then
  echo "  ✓ doc/ncpf.txt has proper header"
else
  echo "  ✗ doc/ncpf.txt missing proper header"
  exit 1
fi
echo ""

echo "=== All checks passed! ==="
echo ""
echo "Plugin structure is valid and ready for distribution."
echo ""
echo "Next steps:"
echo "1. Create a new repository: https://github.com/nowpassion/ncpf.nvim"
echo "2. Copy all files from ncpf.nvim/ directory to the new repository"
echo "3. Commit and push to GitHub"
echo "4. Tag the first release: git tag -a v1.0.0 -m 'Initial release'"
echo "5. Push the tag: git push origin v1.0.0"
