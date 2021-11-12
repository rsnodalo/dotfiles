# dotfiles

This repository contains some configurations (typically dotfiles) or themes that I want to carry over across machines.

## Installation

On an unconfigured machine, i.e. no need to handle for existing dotfiles yet, the steps below ought to be straightforward. If an error occurs, see this [Atlassian tutorial](https://www.atlassian.com/git/tutorials/dotfiles) to handle offending files.

```shell
git clone --bare https://github.com/rsnodalo/dotfiles.git $HOME/.dotfiles
alias git-dotfiles='GIT_DIR=$HOME/.dotfiles/ GIT_WORK_TREE=$HOME git'
git-dotfiles config --local status.showUntrackedFiles no
git-dotfiles checkout
```

If zsh is not the default on the terminal yet, run:

```shell
chsh -s zsh
```

To apply updates, pull the repository just like so:

```shell
git-dotfiles pull
```

## Contents

You will find `.vimrc`, `.zshrc`, and `.p10k.zsh` in the root of this directory. The first two contain the configurations for Vim and Zsh respectively, while `.p10k.zsh` is a generated file for the `powerlevel10k` Zsh theme, i.e. how iTerm2 will look like.

## Essentials

### Packages

- Homebrew
    - pyenv
    - cask
    - karabiner-elements
    - yabai
    - skhd
    - zsh
        - ohmyzsh
        - powerlevel10k
    - vim
        - NERDTree
    - neofetch
    - gotop
    - htop
- pip
    - pandas
    - numpy
    - django
    - ... many others, actually

### Applications

- iTerm2
- Google Chrome
- Visual Studio Code
- Spotify
- Telegram
- Viber
- Discord
- Karabiner

### Others

- [Cloud SDK](https://cloud.google.com/sdk/docs/quickstart)
- [QMK CLI](https://beta.docs.qmk.fm/cli)

## Usage

Once the dotfiles and the appropriate tools that use them of course are set-up... enjoy!

## Acknowledgements

- [Nicola Paolucci for the Atlassian approach to storing dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
- [Jesse Skelton's notes on Notion for yabai, skhd configurations](https://www.notion.so/Yabai-8da3b829872d432fac43181b7ff628fc)
