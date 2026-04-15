# Introduction

[![CI](https://github.com/abhisekmazumdar/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/abhisekmazumdar/dotfiles/actions/workflows/test.yml)

This repository contains my personal dotfiles for setting up a new macOS machine. It includes configurations for development tools, system preferences, and a streamlined setup process.

## Features

* **Shell & Package Management**
  - [Oh My Zsh](https://ohmyz.sh/) for enhanced shell experience
  - [Homebrew](https://brew.sh/) for package management with Brewfile for all apps and binaries
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) for shell suggestions

* **Development Environment**
  - Latest Node.js LTS version via [nvm](https://github.com/nvm-sh/nvm)
  - PHP development tools:
    - `phpcs` & `phpcbf` configured for Drupal coding standards
    - `composer-diff` for comparing Composer dependencies
  - DDEV development environment setup with mkcert
  - Git configuration with global settings and gitignore
  - [Neovim](https://neovim.io/) as terminal editor
  - [Lazygit](https://github.com/jesseduffield/lazygit) for terminal git UI
  - [pnpm](https://pnpm.io/) for fast Node.js package management

* **Apps & Tools**
  - [Ghostty](https://ghostty.org/) terminal
  - [Bruno](https://www.usebruno.com/) API client
  - [Claude Code](https://claude.ai/code) AI CLI
  - [DDEV](https://ddev.com/) local development environment
  - [Ollama](https://ollama.ai/) for running local LLMs

* **System Configuration**
  - Custom macOS defaults for optimal development experience
  - Project directory structure setup
  - Automatic repository cloning for personal projects

## Installation

1. **Prerequisites**
   - Ensure you have SSH keys set up and added to GitHub
   - Have a fresh macOS installation ready

2. **Setup Process**
   ```shell
   # Clone the repository
   git clone --recursive git@github.com:abhisekmazumdar/dotfiles.git ~/.dotfiles

   # Run the installation script
   cd ~/.dotfiles && ./fresh.sh
   ```

The installation script will:
- Install and configure Oh My Zsh
- Set up Homebrew and install all specified packages
- Create symbolic links for configuration files
- Set up development tools and environments
- Configure system preferences
- Optionally clone your GitHub repositories

## Directory Structure

- `brew/` - Homebrew bundle configuration (Brewfile)
- `git/` - Git configuration files (`.gitconfig`, `.gitignore_global`)
- `macos/` - macOS system preferences
- `zsh/` - Zsh configuration files (`.zshrc`, `aliases.zsh`, `path.zsh`)
- `fresh.sh` - Main installation script
- `clone.sh` - Repository cloning script

## CI & Verification

The CI pipeline runs on every push and pull request against a fresh **macOS (Apple Silicon)** GitHub Actions runner. It calls `fresh.sh` directly — the same script you'd run on a new Mac — with two CI-specific adjustments:

| What CI skips | Why |
|---|---|
| GUI cask apps (Arc, PhpStorm, Slack…) | No display server on headless runners |
| macOS system preferences (`.macos`) | No need to set hostname/Dock/Finder on a runner |
| Interactive clone prompt | No user to answer `y/n` |
| `source ~/.zshrc` | Runner uses bash; sourcing a zsh config would fail |

Everything else runs identically to a real Mac: Homebrew, Oh My Zsh, symlinks, nvm + Node LTS, phpcs, phpcbf, composer-diff.

### Last tested locally

| Date | macOS | Chip | Result |
|------|-------|------|--------|
| — | — | — | Update after each full local run |

> After running `./fresh.sh` on your Mac, update the table above and open a PR.

## Optional: Cleaning Your Old Mac

After setting up your new Mac, you may want to clean install your old machine. Follow Apple's official guide for [erasing and reinstalling macOS](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac). Remember to backup your data first!

## License

This project is open source and available under the MIT License.
