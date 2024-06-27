if [ -f "$HOME/.profile" ]; then . "$HOME/.profile"; fi

# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

set -o noclobber
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s extglob
shopt -s globstar

_prompt() {
    export PS1='\[\e[0;97m\]\[\e[90;1m\]\u@\h\[\e[0m\] \w \[\e[32;1m\]→ \[\e[0m\]'
}

export -f _prompt
export PROMPT_COMMAND=_prompt

alias la='eza --icons -a'
alias ll='eza --icons -l'
alias lla='eza --icons -la'
alias ls='eza --icons'
alias ...='../..'
alias ....='../../..'
