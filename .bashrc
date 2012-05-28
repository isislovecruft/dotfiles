# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
	# check because c-n-f could've been removed in the meantime
	if [ -x /usr/lib/command-not-found ]; then
	    /usr/bin/python /usr/lib/command-not-found -- "$1"
	    return $?
	elif [ -x /usr/share/command-not-found/command-not-found ]; then
	    /usr/bin/python /usr/share/command-not-found/command-not-found -- "$1"
	    return $?
	else
	    printf "%s: command not found\n" "$1" >&2
	    return 127
	fi
    }
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=yes
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[34m\]\u\[\033[32m\]@\[\033[36m\]\h\[\033[32m\]:\[\033[32m\]\w\[\033[37m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Extra user defined alaises:
alias e='emacs -nw'
alias ec='emacsclient -t'
alias es='emacs -nw --daemon'
alias s='sudo '
alias whack='/home/isis/scripts/mod_wifi.sh'
alias ag='apt-get'
alias acs='apt-cache search'
alias dev='cd /home/isis/dev'
alias back='cd $OLDPWD'
alias arm='sudo -u debian-tor arm'
## Moved to scripts/ so muttrc can call it:
#alias sprunge="curl --socks4a 127.0.0.1:59050 -A 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0' -F 'sprunge=<-' http://sprunge.us"
alias 30='dmesg | tail -n 30 | ccze -A'
alias 300='dmesg | tail -n 300 | ccze -A'
alias check='ping -c 3 google.com'
alias fuck='sudo killall'
alias rms='rm ./*~'
alias rmp='rm ./\#*#'
alias rme='rm ./*~ && rm ./\#*#'
alias rmc='rm ./*.pyc'
alias tagsc='find . -name "*.[ch]" | xargs etags'
alias tagsp='find . -type f -name "*.py" | xargs etags'
alias removepound="sed -e 's/#.*//;/^$/d'"
alias removeslash="cpp -fpreprocessed"
alias boilerpy="boilerplate.sh $HOME/scripts/boilerplate-python $1 "
alias boilersh="boilerplate.sh $HOME/scripts/boilerplate-bash $1 "
alias gitdate='. gitdate.sh'
alias eip='ip_external.sh'
alias iip="sudo /sbin/ifconfig wlan0|grep inet|head -1|sed 's/\:/ /'|awk '{print $3}'"
alias hyde='$HOME/dev/web/hyde/hyde.py'
#alias tor='sudo tor -f /etc/tor/torrc'
#alias tor='sudo -u debian-tor tor -f /etc/tor/torrc'
alias hieroglyph="echo -e \"\033(0\""
alias pytebeat="aoss $HOME/dev/pytebeat/pytebeat.py"
alias keysign="keysign.sh "
alias fwup="firewall.client.sh"
alias fwdown="sudo iptables -F; sudo iptables -X; sudo iptables -A INPUT -j ACCEPT; sudo iptables -A FORWARD -j ACCEPT; sudo iptables -A OUTPUT -j ACCEPT"
alias offlineimap="offlineimap -c /home/isis/.mailrc/offlineimaprc"
alias torofflineimap="usewithtor offlineimap -c $HOME/.mailrc/offlineimaprc-tor"
alias mutt="mutt-patched"
alias mairix="mairix -f $HOME/.mailrc/mairixrc"
alias N='emacs -nw $HOME/NOTES.gpg'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

## TMUX
if which tmux 2>&1 >/dev/null; then
    ## If no tmux session is started; start a new session:
    if test -z ${TMUX}; then
        ## We actually need to attach to it, because tmux.conf starts
        ## the session for us:
	    #tmux attach
        ## that didn't work...
        ## now .tmux.conf.setup is bound to to a key, so do:
        tmux
        ## Since this usually occurs just after boot, start the
        ## firewall while we're at it:
        $HOME/scripts/firewall.client.sh
    fi
    ## When quitting tmux, try to attach:
    while test -z ${TMUX}; do
	    tmux attach || break
    done
fi

## Environment variables:
#export TZ=UTC                             # Blue telephone box
#export EDITOR=/usr/bin/emacs              # Uses X :(
#export VISUAL=/usr/bin/emacs
export BROWSER=/usr/bin/iceweasel

## Let's make pretty things!
$HOME/scripts/bash_pretty_login.py

## Export path for android NDK
export NDKROOT=$HOME/dev/android/android-ndk-r7

## Export paths for common toolchains for android NDK
## Leave these commented out unless you're specifically cross-compiling for ArmV7
#
#export AR=$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-ar
#export LD=$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-ld
#export CC=$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-gcc

## Add export path for Android SDK platform-tools and tools:
export PATH=${PATH}:$HOME/dev/android/android-sdk-linux/tools:$HOME/dev/android/android-sdk-linux/platform-tools

## Export path to hyde.py
export PATH=${PATH}:$HOME/dev/web/hyde/

## Export path to homebrewed scripts directory
export PATH=$PATH:$HOME/scripts

## Export path to git-hg
export PATH=$PATH:$HOME/dev/git-hg/bin

## Export path for Go
export PATH=$PATH:/usr/local/go/bin