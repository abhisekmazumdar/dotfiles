# Introduction

This repository contains my personal dotfiles for setting up a new macOS machine. It includes configurations for development tools, system preferences, and a streamlined setup process.

## Features

* **Shell & Package Management**
  - [Oh My Zsh](https://ohmyz.sh/) for enhanced shell experience
  - [Homebrew](https://brew.sh/) for package management
  - [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) for managing all applications and binaries

* **Development Environment**
  - Latest Node.js LTS version via nvm
  - PHP development tools:
    - `phpcs` & `phpcbf` configured for Drupal coding standards
    - `composer-diff` for comparing Composer dependencies
  - DDEV development environment setup with mkcert
  - Git configuration with global settings

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

- `brew/` - Homebrew bundle configuration
- `git/` - Git configuration files
- `macos/` - macOS system preferences
- `zsh/` - Zsh configuration files
- `fresh.sh` - Main installation script
- `clone.sh` - Repository cloning script

## GitHub Actions

This repository includes GitHub Actions workflows to automatically test the dotfiles setup in a CI environment:

### Available Workflows

1. **`test.yml`** - Comprehensive testing workflow that:
   - Sets up the complete development environment
   - Installs all Homebrew packages
   - Configures Node.js, PHP, and development tools
   - Verifies all installations and configurations
   - Tests shell configuration

2. **`test-simple.yml`** - Simplified workflow that:
   - Uses the `ci-setup.sh` script for streamlined setup
   - Performs essential verification
   - Faster execution for quick checks

### CI Setup Script

The `ci-setup.sh` script is a non-interactive version of `fresh.sh` designed for CI environments:
- Removes interactive prompts
- Handles error conditions gracefully
- Skips user-specific configurations
- Optimized for automated testing

### Running Tests

The workflows automatically run on:
- Push to `main` branch
- Pull requests to `main` branch
- Manual trigger via workflow_dispatch

You can view test results in the [Actions tab](https://github.com/abhisekmazumdar/dotfiles/actions) of this repository.

## Optional: Cleaning Your Old Mac

After setting up your new Mac, you may want to clean install your old machine. Follow Apple's official guide for [erasing and reinstalling macOS](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac). Remember to backup your data first!

## License

This project is open source and available under the MIT License.