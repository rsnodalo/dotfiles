# Linux-only shell config. Stowed only on Linux (the `linux` package).
alias o='xdg-open'
alias ls='ls --color=auto'

# Clipboard: prefer wl-clipboard (Wayland), fall back to xclip (X11).
if command -v wl-copy >/dev/null 2>&1; then
  alias copy='wl-copy'
  alias paste='wl-paste'
elif command -v xclip >/dev/null 2>&1; then
  alias copy='xclip -selection clipboard'
  alias paste='xclip -selection clipboard -o'
fi

# Add Linux-specific aliases, env vars, and PATH tweaks below.
