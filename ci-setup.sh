#!/bin/bash
# CI-specific setup script — non-interactive, no GUI, no macOS preferences.
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"

echo "==> Checking Xcode Command Line Tools..."
xcode-select -p &>/dev/null && echo "Already installed." || echo "Warning: not found."

# Ensure Homebrew is in PATH (Apple Silicon: /opt/homebrew, Intel: /usr/local)
echo "==> Initialising Homebrew..."
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "Homebrew not found — installing..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew --version

# Install CLI tools (Brewfile.ci — no GUI casks)
echo "==> Installing Homebrew packages..."
HOMEBREW_NO_AUTO_UPDATE=1 \
  brew bundle --file "$DOTFILES_DIR/brew/Brewfile.ci" --no-quarantine --no-lock

# Symlink configs
echo "==> Creating symlinks..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc"            "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/git/.gitconfig"        "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# mkcert (used by ddev; non-fatal in CI)
echo "==> Setting up mkcert..."
mkcert -install || true

# Project directory
mkdir -p "$HOME/Code"

# NVM + Node LTS
echo "==> Installing Node LTS via NVM..."
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"
[ -s "$NVM_SH" ] && \. "$NVM_SH"
nvm install --lts
nvm use --lts
node --version
npm --version

# PHP tools
echo "==> Installing global Composer packages..."
composer global require drupal/coder || true
PHPCS="$HOME/.composer/vendor/bin/phpcs"
if [ -f "$PHPCS" ]; then
  "$PHPCS" --config-set installed_paths \
    "$HOME/.composer/vendor/drupal/coder/coder_sniffer/" || true
  "$PHPCS" -i || true
fi
composer global require ion-bazan/composer-diff || true

echo "==> CI setup complete!"
