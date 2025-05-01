#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ $1 is installed${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 is not installed${NC}"
        return 1
    fi
}

# Function to check if a symlink exists
check_symlink() {
    if [ -L "$1" ]; then
        echo -e "${GREEN}✓ Symlink $1 exists${NC}"
        return 0
    else
        echo -e "${RED}✗ Symlink $1 does not exist${NC}"
        return 1
    fi
}

# Function to check if a directory exists
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

# Check essential commands
echo -e "${YELLOW}Checking essential commands:${NC}"
check_command zsh
check_command brew
check_command git
check_command node
check_command nvm
check_command php
check_command composer
check_command phpcs
check_command phpcbf

# Check symlinks
echo -e "\n${YELLOW}Checking symlinks:${NC}"
check_symlink "$HOME/.zshrc"
check_symlink "$HOME/.gitconfig"
check_symlink "$HOME/.gitignore_global"

# Check directories
echo -e "\n${YELLOW}Checking directories:${NC}"
check_directory "$HOME/Code"
check_directory "$HOME/.nvm"

# Check Homebrew packages
echo -e "\n${YELLOW}Checking Homebrew packages:${NC}"
if command -v brew >/dev/null 2>&1; then
    echo "Installed Homebrew packages:"
    brew list
else
    echo -e "${RED}Homebrew is not installed${NC}"
fi

# Check Node.js version
echo -e "\n${YELLOW}Checking Node.js:${NC}"
if command -v node >/dev/null 2>&1; then
    echo "Node.js version: $(node --version)"
    echo "npm version: $(npm --version)"
else
    echo -e "${RED}Node.js is not installed${NC}"
fi

# Check PHP tools
echo -e "\n${YELLOW}Checking PHP tools:${NC}"
if command -v phpcs >/dev/null 2>&1; then
    echo "PHP_CodeSniffer version: $(phpcs --version)"
    echo "PHP_CodeSniffer installed standards:"
    phpcs -i
else
    echo -e "${RED}PHP_CodeSniffer is not installed${NC}"
fi

# Check shell configuration
echo -e "\n${YELLOW}Testing shell configuration:${NC}"
if [ -f "$HOME/.zshrc" ]; then
    echo "Testing .zshrc configuration..."
    zsh -c 'echo "Shell configuration test successful"'
    zsh -c 'which nvm'
    zsh -c 'nvm --version'
else
    echo -e "${RED}.zshrc file not found${NC}"
fi

# Check git configuration
echo -e "\n${YELLOW}Checking git configuration:${NC}"
if [ -f "$HOME/.gitconfig" ]; then
    echo "Git configuration:"
    git config --list
else
    echo -e "${RED}.gitconfig file not found${NC}"
fi

echo -e "\n${YELLOW}Verification complete!${NC}"