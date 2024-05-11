# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

set -o noclobber
set -o allexport

XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
XDG_BIN_HOME="$HOME/.local/bin"
HISTFILE="$XDG_STATE_HOME/bash/history"

_prompt() {
    PS1="\[\]\t \[\e[36;1m\]\w \n\[\e[0;97m\]\[\e[90;1m\]\u@\h \[\e[32;1m\]→ \[\e[0m\]"
}
PROMPT_COMMAND=_prompt
EDITOR=nvim
PAGER=nvimpager
MANPAGER="nvim +Man!"

set +o allexport

alias la='eza --icons -a'
alias ll='eza --icons -l'
alias lla='eza --icons -la'
alias ls='eza --icons'
alias ...='../..'
alias ....='../../..'

shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s extglob
shopt -s globstar
export PATH=$XDG_BIN_HOME:$PATH
if [[ -d $CARGO_HOME/env ]]; then
  . "$CARGO_HOME/env"
fi
