# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="cursor ~/.zshrc"
alias ohmyzsh="cursor ~/.oh-my-zsh"

# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias open-codes="cd $HOME/Code"
alias open-mautic="cd $HOME/Code/mautic-projects"
alias open-drupal="cd $HOME/Code/drupal-projects"