# Migration Guide

This guide helps you migrate from the ncpf configuration in the dotfile repository to the standalone ncpf.nvim plugin.

## For Users Currently Using Dotfile's ncpf

If you've been using ncpf from the nowpassion/dotfile repository, follow these steps to migrate to the standalone plugin.

### Before Migration

Your current setup (from dotfile repository):
```lua
-- In your init.lua or similar
vim.opt.runtimepath:append('/path/to/dotfile/nvim')
-- ncpf was loaded from dotfile/nvim/plugin/ncpf/init.lua
```

### After Migration

New setup with standalone plugin:

#### Option 1: Using lazy.nvim (Recommended)

```lua
{
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

#### Option 2: Using packer.nvim

```lua
use {
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

#### Option 3: Using vim-plug

```vim
Plug 'nowpassion/ncpf.nvim'
```

Then in your `init.lua`:
```lua
require('ncpf.ncpf').init()
```

### Migration Steps

1. **Remove old dotfile dependency** (if you were only using it for ncpf)
   - Remove any runtimepath additions for the dotfile repository
   - Remove the dotfile repository clone

2. **Add the new plugin**
   - Add ncpf.nvim to your plugin manager configuration
   - Run your plugin manager's install command:
     - lazy.nvim: Will auto-install on next Neovim start
     - packer.nvim: `:PackerInstall`
     - vim-plug: `:PlugInstall`

3. **Verify configuration**
   - Open a C/C++ file in your project
   - Check that ncpf initializes correctly
   - Verify code navigation works (`<C-\>`, `<C-]>`)

### Configuration Changes

No configuration changes are needed! The API remains the same:

```lua
-- Default configuration (searches from $HOME)
require('ncpf.ncpf').init()

-- Custom top directory
require('ncpf.ncpf').init('/path/to/projects')
```

### Project Setup Remains the Same

Your projects don't need any changes:
- Keep your `.nvim_c_project_root` marker files
- Keep your `compile_commands.json`, `cscope.out`, or `tags` files
- Keep your `.ncpf_clangd_option` configuration files

Everything continues to work as before!

### What's Different

The only difference is **where** the plugin comes from:

| Aspect | Old (dotfile) | New (standalone) |
|--------|---------------|------------------|
| Repository | nowpassion/dotfile | nowpassion/ncpf.nvim |
| Installation | Manual runtimepath | Plugin manager |
| Updates | Manual git pull | Plugin manager update |
| Dependencies | Full dotfile repo | Only ncpf code |

### Benefits of Migration

✅ **Cleaner**: Only install what you need  
✅ **Easier updates**: Standard plugin update workflow  
✅ **Better versioning**: Semantic versioning with tagged releases  
✅ **More discoverable**: Listed in plugin directories  
✅ **Better maintained**: Dedicated repository with issues and PRs  

### Rollback (If Needed)

If you encounter issues and need to rollback:

1. Remove the ncpf.nvim plugin from your plugin manager
2. Re-add the dotfile repository to your runtimepath
3. Restart Neovim

### Getting Help

- **Issues**: https://github.com/nowpassion/ncpf.nvim/issues
- **Discussions**: Use GitHub Discussions for questions
- **Documentation**: See README.md and `:help ncpf`

## For Repository Maintainer

### Keeping Both Versions in Sync

If you want to maintain ncpf in both repositories:

#### Option 1: Git Subtree

```bash
# In the dotfile repository
# Push changes to standalone repo
git subtree push --prefix=ncpf.nvim \
  https://github.com/nowpassion/ncpf.nvim.git main

# Pull changes from standalone repo
git subtree pull --prefix=ncpf.nvim \
  https://github.com/nowpassion/ncpf.nvim.git main
```

#### Option 2: Manual Sync

```bash
# Copy from dotfile to standalone
rsync -av --delete dotfile/ncpf.nvim/ ncpf.nvim-standalone/

# Or copy from standalone to dotfile
rsync -av --delete ncpf.nvim-standalone/ dotfile/ncpf.nvim/
```

### Deprecation Notice

Consider adding a deprecation notice to the old location:

```lua
-- In dotfile/nvim/plugin/ncpf/init.lua
vim.notify(
  'ncpf from dotfile is deprecated. Please use standalone ncpf.nvim plugin instead.\n' ..
  'See: https://github.com/nowpassion/ncpf.nvim',
  vim.log.levels.WARN
)
```

## Testing After Migration

Create a simple test project to verify everything works:

```bash
# Create test project
mkdir -p /tmp/test-ncpf/src
cd /tmp/test-ncpf

# Create marker file
touch .nvim_c_project_root

# Create a simple C file
cat > src/main.c << 'EOF'
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int main() {
    printf("Result: %d\n", add(2, 3));
    return 0;
}
EOF

# Generate compile_commands.json
cat > compile_commands.json << 'EOF'
[
  {
    "directory": "/tmp/test-ncpf",
    "command": "gcc -c src/main.c",
    "file": "src/main.c"
  }
]
EOF

# Open in Neovim
nvim src/main.c
```

Then in Neovim:
1. Move cursor to `add` function call
2. Press `<C-]>` - should jump to function definition
3. Press `<C-\>` - should show references

If these work, migration is successful! ✨
