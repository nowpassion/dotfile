# Quick Start Guide

Get started with ncpf.nvim in 5 minutes!

## Prerequisites

- Neovim >= 0.10
- `clangd` installed (recommended) OR one of: cscope, ctags, ccls

Install clangd (recommended):
```bash
# Ubuntu/Debian
sudo apt install clangd

# macOS
brew install llvm

# Arch Linux
sudo pacman -S clang
```

## Installation

### Using lazy.nvim

Add to your `~/.config/nvim/lua/plugins/ncpf.lua`:

```lua
return {
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

Restart Neovim and the plugin will be automatically installed.

### Using packer.nvim

Add to your plugins configuration:

```lua
use {
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

Then run `:PackerInstall`.

## Setup Your First Project

### 1. Navigate to Your C/C++ Project

```bash
cd ~/projects/my-c-project
```

### 2. Create the Project Marker

```bash
touch .nvim_c_project_root
```

This tells ncpf.nvim where your project root is.

### 3. Generate compile_commands.json

#### For CMake projects:

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
```

#### For Makefile projects (using Bear):

```bash
# Install Bear first if needed
# Ubuntu/Debian: sudo apt install bear
# macOS: brew install bear

bear -- make
```

### 4. Open a C/C++ File

```bash
nvim src/main.c
```

You should see ncpf initialize automatically!

## Basic Usage

### Navigation Keybindings

When cursor is on a symbol:

- **`<C-]>`** - Jump to definition
- **`<C-\>`** - Find all references

These work out of the box with clangd/LSP!

### Example Workflow

1. Open a C file: `nvim src/main.c`
2. Move cursor to a function name
3. Press `<C-]>` to jump to its definition
4. Press `<C-o>` to jump back
5. Press `<C-\>` to see all places where the function is called

## Troubleshooting

### "Not found nvim c project file" Error

**Problem**: ncpf can't find `.nvim_c_project_root`

**Solution**: Create it in your project root:
```bash
touch .nvim_c_project_root
```

### "compiledb_path is not exist" Error

**Problem**: Missing `compile_commands.json`

**Solution**: Generate it:
```bash
# CMake
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .

# Makefile with Bear
bear -- make
```

### LSP Not Starting

**Problem**: clangd not found or not working

**Solution**: Verify installation:
```bash
clangd --version
```

If not installed, see [Prerequisites](#prerequisites).

### Key Bindings Not Working

**Problem**: Telescope not installed

**Solution**: Install telescope.nvim:
```lua
-- Add to your plugin config
use 'nvim-telescope/telescope.nvim'
```

## Next Steps

- ✅ **Read the full README**: More detailed documentation
- ✅ **Check examples**: See `examples/README.md` for more setups
- ✅ **Advanced config**: Learn about `.ncpf_clangd_option` for custom clangd settings
- ✅ **Get help**: Create an issue if you have problems

## Common Project Structures

### Simple Project

```
my-project/
├── .nvim_c_project_root    ← Create this
├── compile_commands.json   ← Generate this
└── main.c
```

### CMake Project

```
my-cmake-project/
├── .nvim_c_project_root    ← Create this
├── CMakeLists.txt
├── build/
│   └── compile_commands.json  ← CMake generates this
└── src/
    └── main.c
```

### Multi-directory Project

```
large-project/
├── .nvim_c_project_root    ← Create this
├── compile_commands.json   ← Generate this (or use .ncpf_clangd_option)
├── src/
├── include/
└── tests/
```

## Quick Reference

| File/Directory | Purpose |
|----------------|---------|
| `.nvim_c_project_root` | Marks project root (required) |
| `compile_commands.json` | Build commands for LSP (recommended) |
| `.ncpf_clangd_option` | Custom clangd settings (optional) |

| Key Binding | Action |
|-------------|--------|
| `<C-]>` | Go to definition |
| `<C-\>` | Find references |
| `<C-o>` | Jump back |
| `<C-i>` | Jump forward |

## Tips

💡 **Tip 1**: Place `.nvim_c_project_root` at the actual root of your project for best results

💡 **Tip 2**: Regenerate `compile_commands.json` when you add new files or change build settings

💡 **Tip 3**: Use `:LspInfo` to check if clangd is running

💡 **Tip 4**: For cross-compilation, use `.ncpf_clangd_option` to specify the compiler

## Getting Help

- 📖 **Documentation**: `:help ncpf` in Neovim
- 🐛 **Issues**: https://github.com/nowpassion/ncpf.nvim/issues
- 💬 **Discussions**: GitHub Discussions for questions

Happy coding! 🚀
