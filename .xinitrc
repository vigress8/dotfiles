ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

xhost +si:localuser:$USER &
picom -b &
startxfce4 &
exec xfwm4
