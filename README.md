# Introduction

This is my dotfiles for setting up my macOS.

## What these dotfiles will do!

* It will setup [Oh My Zsh](https://ohmyz.sh/) & [Homebrew](https://brew.sh/).
* It will create symbolic link for the following:
    - `.zshrc`
    - `.gitconfig`
    - `.gitignore_global`
* Using [homebrew/bundle](https://github.com/Homebrew/homebrew-bundle),  it will install all the binaries/apps mentioned in the `./brew/Brewfile`.
* Create a project directory naming it `Code`.
* Clone all the repos mentioned in `./clone.sh`.
* Install the latest node LTS version via nvm.
* Install and set up `phpcs` & `phpcbf` as par Drupal coding standards.
* Set sensible macOS defaults with the file `./macos/macos`.

## Setting up your Mac

After generating/copying the SSH key and adding it to GitHub, follow these steps:

1. Clone the repo to `~/.dotfiles`:
    
    ```shell
    git clone --recursive git@github.com:abhisekmazumdar/dotfiles.git ~/.dotfiles
    ```
2. Run the installation with:

    ```shell
    cd ~/.dotfiles && ./fresh.sh
    ```

## Cleaning the old Mac (optionally)

After you've set up your new Mac you may want to wipe and clean install your old Mac. [Follow this](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac) article to do that. Remember to backup your data first!