# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

####################################################################
####################################################################
### Powerlevel10k-, zsh-, and oh-my-zsh-generated configurations ###
####################################################################
####################################################################

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/Users/bastinodalo/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

###################################################################
###################################################################
##################### Personal configurations #####################
###################################################################
###################################################################
eval "$(/opt/homebrew/bin/brew shellenv)"

export PYENV_ROOT="$HOME"/.pyenv
export PATH="$PYENV_ROOT"/bin:"$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# turn off deprecated pyenv prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export BASE_PROMPT=$PS1
function updatePrompt {
    if [[ "$(pyenv version-name)" != "system" ]]; then
        PYENV_VER=$(pyenv version-name)
        export PS1="(${PYENV_VER%%:*}) "$BASE_PROMPT
    else
        export PS1=$BASE_PROMPT
    fi
}
export PROMPT_COMMAND='updatePrompt'

alias ws="pyenv activate workspace-3.9.4"
alias cns="pyenv activate cns"

alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias yabairc='vim ~/.config/yabai/yabairc'
alias skhdrc="vim ~/.config/skhd/skhdrc"

alias swpfiles="open /Users/bastinodalo/.vim/swap//"

source ~/.zshrc.local
