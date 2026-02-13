# Changelog

All notable changes to ncpf.nvim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-13

### Added
- Initial release of ncpf.nvim as a standalone plugin
- Automatic C/C++ project root detection using `.nvim_c_project_root` marker
- Support for multiple code navigation tools:
  - clangd LSP with compile_commands.json
  - COC with ccls
  - cscope with cscope.out
  - ctags with tags file
- Custom clangd configuration via `.ncpf_clangd_option` file
- Automatic key mapping setup for code navigation
- Comprehensive documentation in README and Vim help format
- MIT License

### Features
- Priority-based tool selection (clangd > coc+ccls > cscope > ctags)
- Flexible project root search with configurable top directory
- Support for C, C++, header files (.c, .cpp, .cc, .h, .hpp)
- Integration with popular Neovim plugins (telescope, nvim-cmp, coc.nvim)
