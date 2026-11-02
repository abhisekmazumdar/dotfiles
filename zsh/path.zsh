# Add directories to the PATH and prevent to add the same directory multiple times upon shell reload.
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Load dotfiles binaries
add_to_path "$DOTFILES/bin"

# Load global Composer tools
add_to_path "$HOME/.composer/vendor/bin"

# Load global Node installed binaries
add_to_path "$HOME/.node/bin"

# Project binaries (vendor/bin, node_modules/.bin) are deliberately not on PATH:
# relative entries would let any cloned repo shadow commands like `git`.
# Use `composer exec`, `npx`/`pnpm exec`, or `ddev` instead.
