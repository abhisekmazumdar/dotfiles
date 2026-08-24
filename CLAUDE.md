# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles for provisioning a new Mac: shell config, Homebrew packages, git config, macOS
system preferences, and the shell scripts that wire it all together. There is no application code —
changes here are shell scripts and config files that get symlinked into `$HOME` or executed directly.

## Commands

- `./fresh.sh` — main install script. Installs Xcode CLT, Oh My Zsh, Homebrew, runs `brew bundle` against
  `brew/Brewfile`, symlinks `.zshrc`/`.gitconfig`/`.gitignore_global` into `$HOME`, installs Node LTS via
  nvm, sets up `phpcs`/`phpcbf` (Drupal coding standards) and `composer-diff`, optionally runs `clone.sh`,
  and applies `macos/.macos` system preferences. Detects CI via the `CI` env var (set automatically by
  GitHub Actions) to skip interactive prompts, GUI casks, and macOS preference changes.
- `./test.sh` — verification script; checks required commands/tools are installed, symlinks exist,
  expected directories exist, and prints installed Homebrew packages / tool versions. Run this after
  `fresh.sh` to confirm the setup worked.
- `./clone.sh` — clones personal GitHub repos (via `gh`) into `~/Code`. Called from `fresh.sh` when the
  user opts in interactively; skipped entirely in CI.
- `./ci-setup.sh` — a leaner, CI-focused equivalent of `fresh.sh` used for local CI debugging (not called
  by the GitHub Actions workflow itself, which calls `fresh.sh` directly with CI-specific env vars).

## CI

`.github/workflows/test.yml` runs on macOS (Apple Silicon) GitHub Actions runners, on push/PR to `main`,
and calls `fresh.sh` directly — the same script used on a real Mac — with these adjustments:

- GUI casks are skipped by building `HOMEBREW_BUNDLE_CASK_SKIP` from every `cask` line in `brew/Brewfile`.
- `macos/.macos` (system preferences) and the interactive `clone.sh` prompt are skipped because `fresh.sh`
  checks `CI=true` (set automatically by Actions).
- `source ~/.zshrc` is skipped in CI since the runner shell is bash, not zsh.

There's a separate `brew/Brewfile.ci` (CLI tools only, no custom taps) used by `ci-setup.sh`, but the
actual GitHub Actions workflow bundles against the real `brew/Brewfile` with casks skipped rather than
using `Brewfile.ci`. Keep this in mind when changing either Brewfile — they are not automatically in sync
and serve different scripts.

## Structure

- `fresh.sh` / `ci-setup.sh` / `clone.sh` / `test.sh` — orchestration scripts (see Commands above).
- `brew/Brewfile` — full package list (binaries, GUI casks, fonts) for real machine setup.
- `brew/Brewfile.ci` — CLI-only subset for `ci-setup.sh`.
- `zsh/.zshrc`, `zsh/aliases.zsh`, `zsh/path.zsh` — shell config, symlinked to `~/.zshrc` by `fresh.sh`.
- `git/.gitconfig`, `git/.gitignore_global` — symlinked into `$HOME`.
- `macos/.macos` — macOS `defaults write` preferences, sourced (not executed) by `fresh.sh` outside CI.

## Conventions when editing

- Scripts must stay idempotent and safe to re-run (`ln -sf`, `mkdir -p`, checks like
  `command -v` / `test !` before installing).
- Any new setup step in `fresh.sh` that isn't CI-safe (GUI, interactive prompts, macOS-only APIs) must be
  gated behind the existing `IS_CI` check, following the pattern already used for casks, `clone.sh`, and
  `.macos`.
- If a new package is added to `brew/Brewfile` as a `cask`, no workflow change is needed — the CI cask
  skip list is derived automatically by grepping `brew/Brewfile`. New `brew` (non-cask) entries do get
  installed in CI.
