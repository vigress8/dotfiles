umask go=

function fenv_if
    test -f $argv[1]; and fenv . $argv[1]
end

fenv_if $HOME/.profile
fenv_if $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
source $HOME/.config/fish/conf.d/**

#if not pgrep -f xserver >/dev/null
#    startx; or sleep 3; startx
#end

if status is-interactive
    # Commands to run in interactive sessions can go here
    oh-my-posh init fish -c $XDG_CONFIG_HOME/fish/themes/catppuccin_latte.omp.json | source
end

