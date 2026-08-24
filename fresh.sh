#!/bin/sh

echo "Setting up your Mac..."

# GitHub Actions (and most CI systems) set CI=true automatically.
# We use this to skip interactive prompts, GUI steps, and macOS preferences.
IS_CI="${CI:-false}"

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p >/dev/null 2>&1; then
  if [ "$IS_CI" = "true" ]; then
    echo "Xcode CLT not found — skipping interactive install in CI."
  else
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
  fi
else
  echo "Xcode Command Line Tools already installed."
fi

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  if [ "$IS_CI" = "true" ]; then
    RUNZSH=no CHSH=no /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
  else
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
  fi
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -f $HOME/.zshrc
ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

# Source the shell config (skip in CI — bash runner cannot source a zsh config)
if [ "$IS_CI" != "true" ]; then
  source ~/.zshrc
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
# In CI, the workflow sets HOMEBREW_BUNDLE_CASK_SKIP so GUI casks are skipped.
brew bundle --file ./brew/Brewfile

# Clean up for Homebrew.
brew cleanup

# For ddev
mkcert -install

# Create project directories
mkdir -p $HOME/Code

# Clone personal GitHub repositories (skip in CI)
if [ "$IS_CI" != "true" ]; then
  echo "Do you want to clone your GitHub repositories? (y/n) [default: y]"
  read -r clone_answer
  clone_answer=${clone_answer:-y}
  if [ "$clone_answer" = "y" ]; then
    ./clone.sh
  fi
fi

# Symlink the git configs to the home directory
ln -sf $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/.dotfiles/git/.gitignore_global $HOME/.gitignore_global

# Point this repo's own git hooks (git/hooks/pre-commit) at gitleaks, so a
# leaked secret is caught before it's committed, not just before it's pushed.
git -C $HOME/.dotfiles config core.hooksPath git/hooks

# Install latest Node LTS via nvm
mkdir -p $HOME/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
nvm install --lts

# Setup phpcs & phpcbf
composer global require drupal/coder
$HOME/.composer/vendor/bin/phpcs --config-set installed_paths $HOME/.composer/vendor/drupal/coder/coder_sniffer/
$HOME/.composer/vendor/bin/phpcs -i

# Setup composer-diff
composer global require ion-bazan/composer-diff
composer diff --help

# Set macOS preferences (skip in CI — headless runner, no system UI)
if [ "$IS_CI" != "true" ]; then
  source ./macos/.macos
fi
