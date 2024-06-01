#!/bin/sh

echo "Setting up your Horus MacBook !!!"

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -sw $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

source ~/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./brew/Brewfile

# Clean up for Homebrew.
brew cleanup

# For ddev
mkcert -install

# Create a projects directories
mkdir $HOME/Code

# Ask if user wants to clone your GitHub repositories with default answer as 'y'
echo "Do you want to clone your GitHub repositories? (y/n) [default: y]"
read -r clone_answer
clone_answer=${clone_answer:-y}
if [ "$clone_answer" = "y" ]; then
  ./clone.sh
fi

# Symlink the git configs to the home directory
ln -sw $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sw $HOME/.dotfiles/git/.gitignore_global $HOME/.gitignore_global

# Install latest node LTS
mkdir ~/.nvm
nvm install --lts

# Setup phpcs & phpcbf
composer global require drupal/coder
$HOME/.composer/vendor/bin/phpcs --config-set installed_paths $HOME/.composer/vendor/drupal/coder/coder_sniffer/
$HOME/.composer/vendor/bin/phpcs -i

# Setup composer-diff
composer global require ion-bazan/composer-diff
composer diff --help

# Set macOS preferences - we will run this last because this will reload the shell
source ./macos/.macos
