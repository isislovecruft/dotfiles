#!/bin/sh

## Reverse the bg and fg colours, default is bg=white fg=black:
#xsetroot -rv
#xsetroot -solid black
#xsetroot -cursor_name top_left_arrow

## Disable audible bell and key clicks:
#xset b off
#xset c off

## Disable screensaver
#xset s off

## Autorepeat on, delay (ms), repeats per second
#xset r rate 200 20

## Energy saver settings (seconds): standby, suspend, off
#xset dpms 300 600 600
#xset dpms on

## stupid keyboard
#[ -f ~/.xmodmaprc ] && xmodmap ~/.xmodmaprc
xmodmap $HOME/.xmodmaprc

## Moved to ~/.config/awesome/autostart.lua:
#xrdb -load $HOME/.Xdefaults

## Qu'est-que fuck?
#ivman &

## Start autocutsel so that we have a $CLIPBOARD:
#autocutsel -fork &
#autocutsel -selection PRIMARY -fork &

## Start rxvt daemon so that shells are threaded inside a single process:
#urxvtd -q -f -o

## we should switch to fish...
export SHELL=/bin/bash

## Start awesome:
exec /usr/bin/awesome