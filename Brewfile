# Brewfile — macOS packages, installed via `brew bundle`.
tap "homebrew/bundle"

brew "stow"    # symlink manager for these dotfiles
brew "zsh"     # newer than the system zsh
brew "neovim"
brew "git"
brew "lazygit" # terminal UI for git (LazyVim <leader>gg)
brew "ripgrep" # fast search — required by LazyVim Telescope/grep
brew "fd"      # fast file finder — used by LazyVim pickers

# Terminal
cask "iterm2"

# Fonts. Nerd Font variants carry the icon glyphs Powerlevel10k + LazyVim need.
cask "font-fira-code-nerd-font" # daily driver: Fira + ligatures + icons
cask "font-meslo-lg-nerd-font"  # Powerlevel10k's reference font (fallback)
# Want to try something new? Uncomment to A/B test:
# cask "font-monaspace-nerd-font"   # GitHub's superfamily, "texture healing"
# cask "font-jetbrains-mono-nerd-font"
