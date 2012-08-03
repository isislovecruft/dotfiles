##############################################################################
# 
# ~/.bashrc 
# --------- 
# Executed by bash(1) for non-login shells.
#
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples.
#
# @author Isis Agora Lovecruft, 0x2cdb8b35
# @date 10 July 2012
# @version 0.1.0
#_____________________________________________________________________________
#
# Changelog:
# ----------
# v0.2.0 Added ttytter though Tor alias and rearranged exports and aliases.
# v0.1.0 Properly added a changelog for vc.
##############################################################################

## If not running interactively, don't do anything
[ -z "$PS1" ] && return

##
## History
################

## Don't put duplicate lines in the history. See bash(1) for more options
## ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

## Append to the history file, don't overwrite it:
shopt -s histappend

## For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

##
## Display
################

## Check the window size after each command and, if necessary,
## update the values of LINES and COLUMNS.
shopt -s checkwinsize

## Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

## If the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
	    ## Check because c-n-f could've been removed in the meantime
	    if [ -x /usr/lib/command-not-found ]; then
	        /usr/bin/python /usr/lib/command-not-found -- "$1"
	        return $?
	    elif [ -x /usr/share/command-not-found/command-not-found ]; then
	        /usr/bin/python /usr/share/command-not-found/command-not-found -- "$1"
	        return $?
	    else
	        printf "%s isn't a fucking command.\n" "$1" >&2
            printf "If you're drunk then you should go for a bike ride, or at least stop coding.\n" "$1" >&2
	        return 127
	    fi
    }
fi

## uncomment for a colored prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	## We have color support; assume it's compliant with Ecma-48
	## (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	## a case would tend to support setf rather than setaf.)
	    color_prompt=yes
    else
	    color_prompt=no
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ "$USER" != "root" ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[33m\]\u\[\033[32m\]@\[\033[36m\]\h\[\033[32m\]:\[\033[32m\]\w\[\033[33m\]\$ \[\033[0m'
    else
        ## If root make the prompt red so that we notice we're in a root shell
        PS1='${debian_chroot:+($debian_chroot)}\[\033[33m\]\u\[\033[32m\]@\[\033[36m\]\h\[\033[32m\]:\[\033[32m\]\w\[\033[31m\]\$ \[\033[0m'
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

## Let's make pretty things!
$HOME/scripts/bash_pretty_login.py

###############################################################################
## Environment & Paths
###############################################################################

## gpg-agent config
#######################
if [ -f "$HOME/.gpg-agent-info" ]; then
    . "$HOME/.gpg-agent-info"
    export GPG_AGENT_INFO
    ## We don't use the following
    #export SSH_AUTH_SOCK
fi

GPG_TTY=$(tty)
export GPG_TTY

## Environment variables
########################
export TZ=UTC                              # Blue telephone box
export LOCALTZ='America/Los_Angeles'
export EDITOR="/usr/bin/emacs -nw"         # (Hopefully this doesn't) Uses X 
export VISUAL="/usr/bin/emacs -nw"
export BROWSER=/usr/bin/firefox
#export SSH_AUTH_SOCK=/tmp/ssh-agent
#export SSH_AGENT_PID=$(pgrep ssh-agent)

## Path 
#######################
export PATH=${PATH}:$HOME/dev/web/hyde/          ## Export path to hyde.py
export PATH=$PATH:$HOME/scripts                  ## Export path to scripts dir
export PATH=$PATH:$HOME/dev/git-hg/bin           ## Export path to git-hg
export PATH=$PATH:/usr/local/go/bin              ## Export path for Go
export PATH=$PATH:$HOME/dev/tahoe-lafs/bin/      ## Export path for Tahoe

## Fix sudo? WTF?
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

export NDKROOT=$HOME/dev/android/android-ndk-r7  ## Export path for android NDK

## Add export path for Android SDK platform-tools and tools:
export PATH=${PATH}:$HOME/dev/android/android-sdk-linux/tools
export PATH=${PATH}:$HOME/dev/android/android-sdk-linux/platform-tools

## Export paths for common toolchains for android NDK
## Leave these commented out unless you're specifically cross-compiling 
## for ArmV7:
#export AR=$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-ar
#export LD=$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-ld
#export CC=$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-gcc

##############################################################################
## Functions
##############################################################################

function goth
{
    while test -z "$LIGHT" ; do
        LIGHT=$(cat /proc/acpi/ibm/light | grep "status:" | cut -c 8-)
    done

    if [[ "$LIGHT" == "         on" ]] || [[ "$LIGHT" == "on" ]] ; then
        sudo echo "off" > /proc/acpi/ibm/light \
            && LIGHT="off"
    elif [[ "$LIGHT" == "         off" ]] || [[ "$LIGHT" == "off" ]] ; then
        sudo echo "on" > /proc/acpi/ibm/light \
            && LIGHT="on"
    else
        LIGHT="off"
        echo; echo "The day star hates you too."; echo;
    fi
}

##############################################################################
## Aliases
##############################################################################

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

## Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## More ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

## Add an "alert" alias for long running commands.  Use like so:
##   $ sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#################################
## Extra user defined alaises: 
#################################

##
## Editing
##############

alias e='emacs -nw'
alias ec='emacsclient -t'
alias es='emacs -nw --daemon'
alias N='emacs -nw $HOME/NOTES.gpg'

##
## Sudo & Apt
##############

alias s='sudo '
alias ag='apt-get'
alias acs='apt-cache search'

##
## Development
################

alias dev='cd /home/isis/dev'
alias back='cd $OLDPWD'
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
alias ipython='ipython --no-banner'

##
## Logs & Processes
###################

alias 30='dmesg | tail -n 30 | ccze -A'
alias 300='dmesg | tail -n 300 | ccze -A'
alias fuck='sudo killall '
alias damn='sudo kill -9 `pgrep $2` '

##
## Networking
#################

alias check='ping -c 3 google.com'
alias fwup="firewall.client.sh"
alias fwdown="sudo iptables -F; sudo iptables -X; sudo iptables -A INPUT -j ACCEPT; sudo iptables -A FORWARD -j ACCEPT; sudo iptables -A OUTPUT -j ACCEPT"
alias fwcheck="sudo iptables -L"
alias eip='ip_external.sh'
alias iip="sudo /sbin/ifconfig wlan0|grep inet|head -1|sed 's/\:/ /'|awk '{print $3}'"
## Moved to scripts/ so muttrc can call it:
#alias sprunge="curl --socks4a 127.0.0.1:59050 -A 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0' -F 'sprunge=<-' http://sprunge.us"

##
## Display
###############
alias trans="transset -d $DISPLAY 0.8 "

##
## Tor Aliases
###############

alias tor='sudo -u debian-tor /usr/local/bin/tor -f /etc/tor/torrc'
alias arm='sudo -u debian-tor arm'
alias mutt="mutt-patched -F $HOME/.mailrc/muttrc"
alias muttor="coproc mailwithtor; mutt-patched -F $HOME/.mailrc/muttrc.tor"
alias offlineimap="offlineimap -c /home/isis/.mailrc/offlineimaprc"
alias torofflineimap="usewithtor offlineimap -c $HOME/.mailrc/offlineimaprc-tor"
alias mairix="mairix -f $HOME/.mailrc/mairixrc"
alias twitter="usewithtor ttytter | ccze -A"

##
## Fucking around
#################

alias hieroglyph="echo -e \"\033(0\""
alias pytebeat="aoss $HOME/dev/pytebeat/pytebeat.py"
alias hyde='$HOME/dev/web/hyde/hyde.py'
alias music='mocp -m $HOME/music -T $HOME/.moc/darkdot_theme -R ALSA'

##############################################################################

## enable programmable completion features (you don't need to enable
## this, if it's already enabled in /etc/bash.bashrc and /etc/profile
## sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

##############################################################################
## TMUX
##############################################################################

#if which tmux 2>&1 >/dev/null; then
#    ## If no tmux session is started; start a new session:
#    if test -z ${TMUX}; then
#        ## Now .tmux.conf.setup is bound to C-h-R, so do:
#        tmux
#
#        ## Actually, iptables-persistent seems to work now...
#        ## ...but if it doesn't, call this from .tmux.conf.setup, so 
#        ## that it is not backgrounded by tmux:
#        #$HOME/scripts/firewall.client.sh
#    fi
#    ## When quitting tmux, try to attach:
#    while test -z ${TMUX}; do
#	    tmux attach || break
#    done
#fi

if test $(which tmux) == "/usr/bin/tmux" ; then
    # If tmux owns zero processes
    if [[ $(pgrep tmux | wc -l) -eq "0" ]] ; then
        tmux
    #else  
        ## XXX need to attach to one, never both!
        #tmux attach || break
    fi
fi
