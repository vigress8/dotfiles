source $HOME/.env
source $HOME/.config/fish/conf.d/**
if not pgrep -f xserver >/dev/null
    startx; or sleep 3; startx
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

