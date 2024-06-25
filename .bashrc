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

prompt=(
    # username@hostname
    '\[\e[0;97m\]\[\e[90;1m\]\u@\h\[\e[0m\]'
    # current working dir
    '\w'
    # fancy arrow
    '\[\e[32;1m\]→ \[\e[0m\]'
)

if [ -n "$IN_NIX_SHELL" ]; then
  prompt=('(nix-shell)' "${prompt[@]}")
fi

_prompt() {
    local IFS=; export PS1=${prompt[*]}
}

export -f _prompt
export PROMPT_COMMAND=_prompt

alias la='eza --icons -a'
alias ll='eza --icons -l'
alias lla='eza --icons -la'
alias ls='eza --icons'
alias ...='../..'
alias ....='../../..'
