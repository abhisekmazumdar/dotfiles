#!/bin/sh

echo "Setting up dotfiles for CI environment..."

# Xcode CLT is pre-installed on GitHub macOS runners; skip interactive install
if ! xcode-select -p &>/dev/null; then
  echo "Warning: Xcode Command Line Tools not found."
else
  echo "Xcode Command Line Tools already installed."
fi

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  RUNZSH=no CHSH=no /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Symlink .zshrc (remove existing before linking)
rm -f $HOME/.zshrc
ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

# Install CLI tools only (GUI casks are not needed in CI)
brew bundle --file ./brew/Brewfile.ci --no-quarantine

# Clean up Homebrew
brew cleanup

# For ddev
mkcert -install || true

# Create projects directory
mkdir -p $HOME/Code

# Skip GitHub repository cloning in CI
echo "Skipping GitHub repository cloning in CI environment"

# Symlink the git configs to the home directory
ln -sf $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/.dotfiles/git/.gitignore_global $HOME/.gitignore_global

# Install latest node LTS via NVM
mkdir -p $HOME/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
nvm install --lts
nvm use --lts

# Setup phpcs & phpcbf
composer global require drupal/coder || true
if [ -f "$HOME/.composer/vendor/bin/phpcs" ]; then
  $HOME/.composer/vendor/bin/phpcs --config-set installed_paths $HOME/.composer/vendor/drupal/coder/coder_sniffer/ || true
  $HOME/.composer/vendor/bin/phpcs -i || true
fi

# Setup composer-diff
composer global require ion-bazan/composer-diff || true
composer diff --help || true

# Skip macOS preferences in CI
echo "Skipping macOS preferences in CI environment"

echo "CI setup completed successfully!"
