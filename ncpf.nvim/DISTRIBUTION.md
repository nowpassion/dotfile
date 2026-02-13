# Distribution Guide

This guide explains how to distribute ncpf.nvim as a separate repository.

## Current Status

The ncpf.nvim plugin is currently packaged within the `ncpf.nvim/` directory of the dotfile repository. It's ready to be distributed as a standalone Neovim plugin.

## Option 1: Create a Separate Repository (Recommended)

### Steps to Create Standalone Repository

1. **Create a new GitHub repository**
   ```bash
   # On GitHub, create a new repository named 'ncpf.nvim'
   ```

2. **Extract and push the plugin code**
   ```bash
   # Clone the dotfile repo
   git clone https://github.com/nowpassion/dotfile.git
   cd dotfile
   
   # Create a new directory for the standalone plugin
   cd ..
   mkdir ncpf.nvim-standalone
   cd ncpf.nvim-standalone
   
   # Initialize git
   git init
   
   # Copy all plugin files from dotfile/ncpf.nvim
   cp -r ../dotfile/ncpf.nvim/* .
   
   # Add all files
   git add .
   
   # Commit
   git commit -m "Initial commit: ncpf.nvim plugin"
   
   # Add remote and push
   git remote add origin https://github.com/nowpassion/ncpf.nvim.git
   git branch -M main
   git push -u origin main
   ```

3. **Tag the first release**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

### Using the Standalone Repository

Once published, users can install it directly:

```lua
-- With lazy.nvim
{
  'nowpassion/ncpf.nvim',
  ft = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  config = function()
    require('ncpf.ncpf').init()
  end,
}
```

## Option 2: Git Subtree (Alternative)

If you want to maintain the plugin in both repositories:

```bash
# From the dotfile repository
git subtree split --prefix=ncpf.nvim -b ncpf-plugin

# Create the new repository and add this branch as the source
cd ../ncpf.nvim-standalone
git init
git pull ../dotfile ncpf-plugin
git remote add origin https://github.com/nowpassion/ncpf.nvim.git
git push -u origin main
```

## Option 3: Keep in Dotfile Repository

Users can also install directly from the dotfile repository:

```lua
-- With lazy.nvim
{
  'nowpassion/dotfile',
  dir = vim.fn.stdpath('data') .. '/lazy/dotfile/ncpf.nvim',
  config = function()
    vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/dotfile/ncpf.nvim')
    require('ncpf.ncpf').init()
  end,
}
```

But this is not recommended as it downloads the entire dotfile repository.

## Maintenance

### Updating the Plugin

When making changes:

1. **If using separate repository**:
   - Make changes in the ncpf.nvim repository directly
   - Update CHANGELOG.md
   - Tag new versions
   - (Optionally) sync back to dotfile repo

2. **If using git subtree**:
   - Make changes in either repository
   - Use git subtree push/pull to sync

### Versioning

Follow [Semantic Versioning](https://semver.org/):
- MAJOR version: Breaking changes
- MINOR version: New features (backward compatible)
- PATCH version: Bug fixes (backward compatible)

Example tags:
- v1.0.0 - Initial release
- v1.1.0 - Add new feature
- v1.1.1 - Bug fix
- v2.0.0 - Breaking change

## Publishing to Plugin Aggregators

### awesome-neovim

Submit a PR to add ncpf.nvim:
https://github.com/rockerBOO/awesome-neovim

### neovimcraft

The plugin will be automatically discovered if it follows Neovim plugin conventions (which it does).

## Recommended Approach

The **recommended approach** is **Option 1** (separate repository) because:

1. ✅ Users get only what they need
2. ✅ Easier to maintain and version
3. ✅ Better discoverability
4. ✅ Cleaner git history
5. ✅ Standard plugin installation workflow

## Directory Structure Reference

The plugin follows standard Neovim plugin structure:

```
ncpf.nvim/
├── plugin/          # Auto-loaded on startup
│   └── ncpf.lua     # Plugin initialization
├── lua/             # Lua modules
│   └── ncpf/
│       ├── ncpf.lua     # Main module
│       └── ncpf_lib.lua # Library functions
├── doc/             # Vim help documentation
│   └── ncpf.txt
├── examples/        # Usage examples
├── README.md        # Main documentation
├── LICENSE          # MIT License
├── CHANGELOG.md     # Version history
├── CONTRIBUTING.md  # Contribution guidelines
└── .gitignore       # Git ignore patterns
```

This structure is compatible with all major Neovim plugin managers.
