if test -f $HOME/.env
    source $HOME/.env
end

source $HOME/.config/fish/conf.d/**

set hmvars $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
if test -f $hmvars
    fenv ". $hmvars"
end

#if not pgrep -f xserver >/dev/null
#    startx; or sleep 3; startx
#end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

