# ncpf.nvim

**NCPF** (Neovim C Project File) is a Neovim plugin that automatically detects and configures C/C++ project environments for code navigation and LSP support.

## Features

- 🔍 **Automatic Project Root Detection**: Finds project root using marker files
- 🚀 **Multiple Code Navigation Tools Support**:
  - LSP with clangd (primary)
  - COC with ccls
  - cscope
  - ctags
- ⚙️ **Flexible Configuration**: Customizable project root markers and paths
- 🎯 **Smart Key Mappings**: Automatic setup of code navigation keybindings

## Requirements

### Required
- Neovim >= 0.10
- At least one of the following code navigation tools:
  - clangd (recommended)
  - cscope
  - ctags
  - ccls with coc.nvim

### Optional Dependencies
For full functionality, install these Neovim plugins:
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - For clangd LSP support
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - For completion support
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - For LSP reference/definition finder
- [coc.nvim](https://github.com/neoclide/coc.nvim) - For ccls support
- [cws](https://github.com/dhananjaylatkar/cscope_maps.nvim) - For cscope support (if available)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nowpassion/ncpf.nvim'
```

Then in your `init.lua`:
```lua
require('ncpf.ncpf').init()
```

## Usage

### Basic Setup

Add this to your Neovim configuration:

```lua
-- Default setup (searches from $HOME directory)
require('ncpf.ncpf').init()
```

### Custom Configuration

You can customize the top directory for project search:

```lua
-- Limit search to specific directory
require('ncpf.ncpf').init('/path/to/your/projects')
```

### Project Setup

1. Create a marker file in your project root:
   ```bash
   touch .nvim_c_project_root
   ```

2. Ensure you have one of the following in your project:
   - `compile_commands.json` (for clangd LSP)
   - `cscope.out` (for cscope)
   - `tags` (for ctags)
   - `.ccls-cache/` (for ccls)

3. Open any C/C++ file in your project, and ncpf will automatically:
   - Detect the project root
   - Configure the appropriate code navigation tool
   - Set up key mappings

### Generating compile_commands.json

For LSP support with clangd, you need `compile_commands.json`:

#### Using CMake:
```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
```

#### Using Bear (for Makefile projects):
```bash
bear -- make
```

### Advanced clangd Configuration

Create a `.ncpf_clangd_option` file in your project root to customize clangd:

```
--compile-commands-dir=/path/to/build
--query-driver=/path/to/cross-compiler/gcc
```

## Key Mappings

When using **clangd LSP** (requires telescope.nvim):
- `<C-\>` - Find references (`:Telescope lsp_references`)
- `<C-]>` - Go to definition (`:Telescope lsp_definitions`)

When using **cscope**:
- `<C-\>` - Find symbol references
- `<C-]>` - Go to tag

When using **COC + ccls**:
- `<C-\>` - Find references
- `<C-]>` - Go to definition (uses CocTagFunc)

## How It Works

1. **Project Detection**: When you open a C/C++ file, ncpf searches upward from the current directory to find `.nvim_c_project_root`
2. **Tool Selection**: Checks for available code navigation tools in priority order:
   - clangd with compile_commands.json
   - coc.nvim with ccls
   - cscope with cscope.out
   - ctags with tags file
3. **Auto Configuration**: Automatically configures the first available tool and sets up appropriate key mappings

## Troubleshooting

### "Not found nvim c project file" Error
- Ensure `.nvim_c_project_root` exists in your project root
- Check that the current file is within the search scope (default: $HOME)

### "compiledb_path is not exist" Error
- Generate `compile_commands.json` using CMake or Bear
- Verify the file exists in your project root or the path specified in `.ncpf_clangd_option`

### LSP Not Working
- Ensure clangd is installed: `clangd --version`
- Check that `compile_commands.json` is valid JSON
- Verify nvim-lspconfig and nvim-cmp are installed

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

nowpassion

## Related Projects

- [clangd](https://clangd.llvm.org/) - C/C++ language server
- [cscope](http://cscope.sourceforge.net/) - Developer's tool for browsing source code
- [universal-ctags](https://github.com/universal-ctags/ctags) - Generate tag files
