#!/bin/sh

## stupid keyboard
#[ -f ~/.xmodmaprc ] && xmodmap ~/.xmodmaprc
xmodmap $HOME/.xmodmaprc
xmodmap $HOME/.xmodmaprc.esc-caps-switch

## Start rxvt daemon so that shells are threaded inside a single process:
#urxvtd -q -f -o

## we should switch to fish...
export SHELL=/bin/bash
export LOCALTZ='America/Los_Angeles'

## Start awesome:
exec /usr/bin/awesome