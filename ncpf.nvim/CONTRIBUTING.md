# Contributing to ncpf.nvim

Thank you for considering contributing to ncpf.nvim! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- A clear description of the problem
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your environment (Neovim version, OS, etc.)
- Relevant configuration

### Suggesting Features

Feature suggestions are welcome! Please create an issue with:
- A clear description of the feature
- Use cases and motivation
- Any implementation ideas you may have

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature or bugfix
3. Make your changes
4. Test your changes thoroughly
5. Update documentation as needed
6. Submit a pull request with a clear description

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/nowpassion/ncpf.nvim.git
   ```

2. For testing, you can use the plugin locally by adding to your Neovim config:
   ```lua
   vim.opt.runtimepath:append('/path/to/ncpf.nvim')
   require('ncpf.ncpf').init()
   ```

## Code Style

- Follow Lua best practices
- Use clear, descriptive variable and function names
- Add comments for complex logic
- Keep functions focused and single-purpose
- Maintain consistency with existing code style

## Testing

Before submitting a PR, please test your changes with:
- Different project configurations
- Multiple code navigation tools (clangd, cscope, ctags)
- Various C/C++ project structures

## Documentation

- Update README.md for user-facing changes
- Update doc/ncpf.txt for Vim help documentation
- Update CHANGELOG.md following Keep a Changelog format
- Add code comments for complex implementations

## Questions?

Feel free to create an issue for any questions or discussions about the project.

Thank you for your contributions!
