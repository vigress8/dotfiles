if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

set -gx EDITOR nvim
set -gx PAGER nvimpager
set -gx MANPAGER "nvim +Man!"

set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_BIN_HOME $HOME/.local/bin

set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx DOCKER_HOST unix://$XDG_RUNTIME_DIR/docker.sock
set -gx DOTNET_CLI_HOME $XDG_DATA_HOME/dotnet
set -gx GOPATH $XDG_DATA_HOME/go
set -gx HISTFILE $XDG_STATE_HOME/bash/history
set -gx ICEAUTHORITY $XDG_CACHE_HOME/ICEauthority
set -gx NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -gx PARALLEL_HOME $XDG_CONFIG_HOME/parallel
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/pythonrc
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx WINEPREFIX $XDG_DATA_HOME/wine

# Haskell
set -gx CABAL_CONFIG $XDG_CONFIG_HOME/cabal/config
set -gx CABAL_DIR $XDG_DATA_HOME/cabal
set -gx GHCUP_USE_XDG_DIRS 1
set -gx STACK_XDG 1

fish_add_path -P --prepend $HOME/.nix-profile/bin
fish_add_path -P --prepend $XDG_BIN_HOME
fish_add_path -P --prepend $CARGO_HOME/bin
fish_add_path -P --prepend $XDG_CONFIG_HOME/emacs/bin

oh-my-posh init fish -c $XDG_CONFIG_HOME/fish/themes/catppuccin_latte.omp.json | source

alias g git
alias v nvim
alias wget    'wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias la      'eza --icons -a'
alias ll      'eza --icons -l'
alias lla     'eza --icons -la'
alias ls      'eza --icons'

abbr --add discordo "discordo -token \$DISCORD_AUTH_TOKEN"
