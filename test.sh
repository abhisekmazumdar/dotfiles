#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ $1 is installed${NC}"
    return 0
  else
    echo -e "${RED}✗ $1 is not installed${NC}"
    return 1
  fi
}

check_symlink() {
  if [ -L "$1" ]; then
    echo -e "${GREEN}✓ Symlink $1 exists${NC}"
    return 0
  else
    echo -e "${RED}✗ Symlink $1 does not exist${NC}"
    return 1
  fi
}

check_directory() {
  if [ -d "$1" ]; then
    echo -e "${GREEN}✓ Directory $1 exists${NC}"
    return 0
  else
    echo -e "${RED}✗ Directory $1 does not exist${NC}"
    return 1
  fi
}

echo -e "${YELLOW}Starting dotfiles verification...${NC}\n"

echo -e "${YELLOW}Checking essential commands:${NC}"
check_command zsh
check_command brew
check_command git
check_command node
check_command php
check_command composer
check_command phpcs
check_command phpcbf

# NVM is a shell function, not a binary — source it before checking
echo -e "${YELLOW}Checking NVM:${NC}"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
if type nvm >/dev/null 2>&1; then
  echo -e "${GREEN}✓ nvm is available${NC}"
else
  echo -e "${RED}✗ nvm is not available${NC}"
fi

echo -e "\n${YELLOW}Checking symlinks:${NC}"
check_symlink "$HOME/.zshrc"
check_symlink "$HOME/.gitconfig"
check_symlink "$HOME/.gitignore_global"

echo -e "\n${YELLOW}Checking directories:${NC}"
check_directory "$HOME/Code"
check_directory "$HOME/.nvm"

echo -e "\n${YELLOW}Checking Homebrew packages:${NC}"
if command -v brew >/dev/null 2>&1; then
  echo "Installed formulae:"
  brew list --formula
else
  echo -e "${RED}Homebrew is not installed${NC}"
fi

echo -e "\n${YELLOW}Checking Node.js:${NC}"
if command -v node >/dev/null 2>&1; then
  echo "Node.js version: $(node --version)"
  echo "npm version: $(npm --version)"
else
  echo -e "${RED}Node.js is not installed${NC}"
fi

echo -e "\n${YELLOW}Checking PHP tools:${NC}"
if command -v phpcs >/dev/null 2>&1; then
  echo "PHP_CodeSniffer version: $(phpcs --version)"
  echo "Installed standards:"
  phpcs -i
else
  echo -e "${RED}PHP_CodeSniffer is not installed${NC}"
fi

echo -e "\n${YELLOW}Testing shell configuration:${NC}"
if [ -f "$HOME/.zshrc" ]; then
  zsh -c 'echo "Shell configuration test successful"'
else
  echo -e "${RED}.zshrc file not found${NC}"
fi

echo -e "\n${YELLOW}Checking git configuration:${NC}"
if [ -f "$HOME/.gitconfig" ]; then
  git config --list
else
  echo -e "${RED}.gitconfig file not found${NC}"
fi

echo -e "\n${YELLOW}Verification complete!${NC}"
