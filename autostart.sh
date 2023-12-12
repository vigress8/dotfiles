#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#start sxhkd to replace Qtile native key-bindings
#run sxhkd -c ~/.config/qtile/sxhkd/sxhkdrc &
#start mpd
#[ ! -s ~/.config/mpd/pid ] && mpd &

#clipmenud &
#ssh-add &
dunst &
picom -b &
~/.fehbg &
nm-applet --indicator &
blueman-applet &
rofi-polkit-agent &
/usr/lib/geoclue-2.0/demos/agent &
playerctld daemon &
dex -as "~/.config/autostart" &
#xhost +si:localuser:$USER &
