# ============================================================================
#  .zshrc  —  shared across macOS and Linux (managed by GNU Stow)
#  OS-specific bits live in ~/.config/zsh/conf.d/, provided by the macos/ or
#  linux/ Stow package. Machine-only/secret bits go in ~/.zshrc.local.
# ============================================================================

# ---- Powerlevel10k instant prompt (must stay near the top) -----------------
# Code that needs console input (passwords, y/n prompts) must go ABOVE this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- PATH ------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH" # user binaries (Claude Code installs here)

# ---- Homebrew (portable: macOS ARM, macOS Intel, Linuxbrew) ----------------
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x "$_brew" ]]; then eval "$("$_brew" shellenv)"; break; fi
done
unset _brew

# ---- Oh My Zsh -------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ---- Editor ----------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
alias vim="nvim"
alias vi="nvim"

# ---- Drop-in config: per-OS (macos/linux package) and per-machine ----------
# Each OS Stow package drops a file here; nothing in this file needs to change.
if [[ -d "$HOME/.config/zsh/conf.d" ]]; then
  for _f in "$HOME/.config/zsh/conf.d/"*.zsh(N); do source "$_f"; done
  unset _f
fi

# ---- Powerlevel10k prompt config -------------------------------------------
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ---- Machine-local, untracked overrides (secrets, work-only paths) ---------
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
