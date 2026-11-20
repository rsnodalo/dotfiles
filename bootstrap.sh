#!/usr/bin/env bash
# ============================================================================
#  bootstrap.sh — set up a machine from this dotfiles repo.
#  Idempotent (safe to re-run). Works on macOS and Linux.
#
#  Usage:   git clone <repo> ~/dotfiles && ~/dotfiles/bootstrap.sh
# ============================================================================
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }

detect_os() {
  case "$(uname -s)" in
    Darwin) echo macos ;;
    Linux)  echo linux ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
  esac
}
OS="$(detect_os)"

# ---- package installation --------------------------------------------------
ensure_xcode_clt() {
  # Command Line Tools provide git + compilers. On a fresh Mac they're absent.
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools present"
  else
    log "Installing Xcode Command Line Tools (git + compilers)"
    xcode-select --install || true
    warn "A GUI installer opened. Finish it, then re-run this script."
    exit 1
  fi
}

install_packages_macos() {
  ensure_xcode_clt
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  log "Installing packages from Brewfile"
  brew bundle --file="$DOTFILES/Brewfile"
}

install_packages_linux() {
  log "Installing packages via system package manager"
  if   command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y stow zsh neovim git curl ripgrep fd-find
  elif command -v dnf    >/dev/null 2>&1; then
    sudo dnf install -y stow zsh neovim git curl ripgrep fd-find
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm stow zsh neovim git curl ripgrep fd
  else
    warn "No supported package manager (apt/dnf/pacman). Install stow, zsh, neovim, git manually."
  fi
}

# lazygit isn't in every distro's default repos (notably Debian/Ubuntu apt),
# so install via package manager when available, else the GitHub release binary.
install_lazygit() {
  [[ "$OS" == macos ]] && return # handled by Brewfile
  command -v lazygit >/dev/null 2>&1 && { log "lazygit already installed"; return; }
  if   command -v dnf    >/dev/null 2>&1 && sudo dnf install -y lazygit;          then return
  elif command -v pacman >/dev/null 2>&1 && sudo pacman -S --noconfirm lazygit;   then return
  fi
  log "Installing lazygit from GitHub release"
  local ver arch tmp
  ver="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep -oP '"tag_name":\s*"v\K[^"]+')" || { warn "could not resolve lazygit version"; return; }
  case "$(uname -m)" in
    x86_64|amd64)  arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) warn "unknown arch $(uname -m); install lazygit manually"; return ;;
  esac
  tmp="$(mktemp -d)"
  if curl -fsSL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${ver}_Linux_${arch}.tar.gz" -o "$tmp/lg.tar.gz" \
     && tar -xzf "$tmp/lg.tar.gz" -C "$tmp" lazygit; then
    mkdir -p "$HOME/.local/bin"
    install "$tmp/lazygit" "$HOME/.local/bin/lazygit"
  else
    warn "lazygit download failed; install it manually"
  fi
  rm -rf "$tmp"
}

# ---- zsh ecosystem ---------------------------------------------------------
install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log "Oh My Zsh already present"
  else
    log "Installing Oh My Zsh"
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

clone_or_update() { # $1 = repo url, $2 = destination
  if [[ -d "$2/.git" ]]; then
    git -C "$2" pull --ff-only --quiet 2>/dev/null || warn "could not update $2"
  else
    git clone --depth=1 "$1" "$2"
  fi
}

install_zsh_extras() {
  log "Installing Powerlevel10k + plugins"
  clone_or_update https://github.com/romkatv/powerlevel10k.git            "$ZSH_CUSTOM/themes/powerlevel10k"
  clone_or_update https://github.com/zsh-users/zsh-autosuggestions.git     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
}

# ---- Claude Code -----------------------------------------------------------
install_claude_code() {
  if command -v claude >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/claude" ]]; then
    log "Claude Code already installed"
  else
    log "Installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

# ---- stow ------------------------------------------------------------------
backup_if_real_file() { # move aside a real (non-symlink) file so stow won't refuse
  if [[ -e "$1" && ! -L "$1" ]]; then
    warn "backing up existing $1 -> $1.pre-dotfiles"
    mv "$1" "$1.pre-dotfiles"
  fi
}

stow_packages() {
  if ! command -v stow >/dev/null 2>&1; then
    warn "stow not installed; skipping symlinks"
    return
  fi
  backup_if_real_file "$HOME/.zshrc"
  backup_if_real_file "$HOME/.p10k.zsh"

  # Ensure ~/.claude exists as a real dir so Stow links only settings.json,
  # not the whole directory (which Claude fills with local state).
  mkdir -p "$HOME/.claude"

  local shared=(zsh p10k nvim claude)
  log "Stowing shared packages: ${shared[*]}"
  stow --dir="$DOTFILES" --target="$HOME" --restow "${shared[@]}"

  if [[ -d "$DOTFILES/$OS" ]]; then
    log "Stowing OS package: $OS"
    stow --dir="$DOTFILES" --target="$HOME" --restow "$OS"
  fi
}

# ---- LazyVim ---------------------------------------------------------------
sync_lazyvim() {
  command -v nvim >/dev/null 2>&1 || { warn "nvim not found; skipping plugin sync"; return; }
  log "Installing Neovim plugins (LazyVim) — headless"
  nvim --headless "+Lazy! sync" +qa 2>/dev/null \
    || warn "Plugin sync didn't complete; it will finish on first 'nvim' launch"
}

# ---- main ------------------------------------------------------------------
main() {
  log "Bootstrapping from $DOTFILES  (os: $OS)"
  case "$OS" in
    macos) install_packages_macos ;;
    linux) install_packages_linux ;;
  esac
  install_oh_my_zsh
  install_zsh_extras
  install_claude_code
  install_lazygit
  stow_packages
  sync_lazyvim

  log "Done. Start a new shell:  exec zsh"
  if [[ "$OS" == linux && "${SHELL:-}" != *zsh ]]; then
    warn 'Make zsh your default shell:  chsh -s "$(command -v zsh)"'
  fi
}

main "$@"
