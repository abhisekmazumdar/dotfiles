#!/bin/sh

echo "Setting up dotfiles for CI environment..."

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
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
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.bash_profile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

# Source the configuration (non-interactive)
source ~/.zshrc || true

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./brew/Brewfile --no-quarantine

# Clean up for Homebrew.
brew cleanup

# For ddev
mkcert -install || true

# Create a projects directories
mkdir -p $HOME/Code

# Skip GitHub repository cloning in CI
echo "Skipping GitHub repository cloning in CI environment"

# Symlink the git configs to the home directory
ln -sf $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/.dotfiles/git/.gitignore_global $HOME/.gitignore_global

# Install latest node LTS
mkdir -p ~/.nvm
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