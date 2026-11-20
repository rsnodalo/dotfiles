# dotfiles

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Cross-platform: **macOS** and **Linux**.

## Fresh machine

### 1. Prerequisites (one-time)

A brand-new machine has no `git`, so you can't clone yet.

**macOS** — install the Command Line Tools (this is where `git` comes from).
Run this and finish the GUI installer that appears:

```sh
xcode-select --install
```

**Linux** — install git with your package manager, e.g.
`sudo apt install -y git` / `sudo dnf install -y git` / `sudo pacman -S git`.

(No GitHub login needed if this repo is public — cloning over HTTPS is anonymous.
Login/SSH is only required to *push*, or if you make the repo private.)

### 2. Clone and bootstrap

```sh
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh
exec zsh
```

`bootstrap.sh` is idempotent — safe to re-run any time. It:

1. Installs packages (Homebrew + `Brewfile` on macOS; apt/dnf/pacman on Linux).
2. Installs Oh My Zsh, Powerlevel10k, and zsh plugins.
3. Symlinks configs into `$HOME` with Stow (shared packages + the current OS package).

After first run, set your terminal font to **MesloLGS NF** so Powerlevel10k icons render.

## Layout

```
dotfiles/
├── bootstrap.sh        # installer
├── Brewfile            # macOS packages
├── zsh/.zshrc          # shared shell config
├── p10k/.p10k.zsh      # Powerlevel10k prompt
├── nvim/.config/nvim/  # Neovim
├── macos/              # macOS-only — stowed only on Darwin
└── linux/              # Linux-only  — stowed only on Linux
```

Each top-level folder is a **Stow package** whose contents mirror `$HOME`.
`stow zsh` links `zsh/.zshrc` → `~/.zshrc`, and so on.

## How per-OS config stays clean

The shared `.zshrc` never contains OS `if/else` branches. Instead it sources
every `*.zsh` in `~/.config/zsh/conf.d/`. The `macos/` and `linux/` packages
each drop one file there, and only the current OS's package is stowed. To add
OS-specific behavior, edit that package's `conf.d` file — nothing shared changes.

Machine-local or secret settings go in `~/.zshrc.local` (untracked).

## Everyday use

```sh
stow <pkg>            # link a package into $HOME       (run from ~/dotfiles)
stow -D <pkg>         # unlink it
stow -R <pkg>         # re-link after adding files
```

Add a new config (e.g. tmux):

```sh
mkdir -p ~/dotfiles/tmux
mv ~/.tmux.conf ~/dotfiles/tmux/.tmux.conf
cd ~/dotfiles && stow tmux
```

Then commit and push — the file is now tracked.
