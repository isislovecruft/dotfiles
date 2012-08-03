#!/bin/sh

## Reverse the bg and fg colours, default is bg=white fg=black:
#xsetroot -rv
#xsetroot -solid black
#xsetroot -cursor_name top_left_arrow

#xset s off

#xset dpms 300 600 600

xmodmap $HOME/.xmodmaprc

## Moved to ~/.config/awesome/autostart.lua:
#xrdb -load $HOME/.Xdefaults

## Qu'est-que fuck?
#ivman &

## we should switch to fish...
export SHELL=/bin/bash

## stupid keyboard
#[ -f ~/.xmodmaprc ] && xmodmap ~/.xmodmaprc

## Start autocutsel so that we have a $CLIPBOARD:
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

## Start rxvt daemon so that shells are threaded inside a single process:
#urxvtd -q -f -o

## Start awesome:
exec /usr/bin/awesome