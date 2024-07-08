# shellcheck shell=sh disable=2034
umask u=rwx,go=rx

prepend_paths() {
    for d_; do
        [ -d "$d_" ] || continue
        case :$PATH: in
        *:"$d_":*) ;;
        *) PATH=$d_:$PATH ;;
        esac
    done
    unset d_
}

set -o allexport

XDG_CACHE_HOME=$HOME/.cache
XDG_CONFIG_HOME=$HOME/.config
XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state
XDG_BIN_HOME=$HOME/.local/bin

if [ -x "$(command -v nvim)" ]; then
    EDITOR=nvim
    MANPAGER='nvim +Man!'
fi

if [ -x "$(command -v bat)" ]; then
    PAGER=bat
fi

CARGO_HOME=$XDG_DATA_HOME/cargo
DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
DOTNET_CLI_HOME=$XDG_DATA_HOME/dotnet
GOPATH=$XDG_DATA_HOME/go
HISTFILE=$XDG_STATE_HOME/bash/history
ICEAUTHORITY=$XDG_CACHE_HOME/ICEauthority
NODE_REPL_HISTORY=$XDG_DATA_HOME/node_repl_history
NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
PARALLEL_HOME=$XDG_CONFIG_HOME/parallel
PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
RUSTUP_HOME=$XDG_DATA_HOME/rustup
WINEPREFIX=$XDG_DATA_HOME/wine

CABAL_CONFIG=$XDG_CONFIG_HOME/cabal/config
CABAL_DIR=$XDG_DATA_HOME/cabal
GHCUP_USE_XDG_DIRS=1
STACK_XDG=1

if [ -f "$HOME/.env" ]; then . "$HOME/.env"; fi

prepend_paths \
    "$XDG_BIN_HOME" \
    "$HOME/.nix-profile/bin" \
    "$CARGO_HOME/bin" \
    "$XDG_CONFIG_HOME/emacs/bin"

set +o allexport
# vim: set ts=4 sw=4 et:
