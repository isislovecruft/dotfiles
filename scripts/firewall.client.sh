#!/bin/bash
##############################################################################
# TOR CLIENT IPTABLES FIREWALL
##############################################################################
# For use on a Tor Client with an optional TransProxy'd anonymous user.
#
# @author Isis Lovecruft, 0x2cdb8b35
# @version 0.0.4
# @license WTFPL
#_____________________________________________________________________________
#
# Changelog:
#
# v0.0.4: Allow DHCP (even though it's a piece of shit). Added reverse path
#         filter to disallow iface transversal. Changed license to "Do What
#         The Fuck You Want Public Licence". Added better logs too.
# v0.0.3: Fixed quotes around $TRANSPROXY_USER variable. Fixed blocking of 
#         Tor's DNSPort. Allow incoming Bittorrent requests.
# v0.0.2: Added TransProxy user rules. TransProxy'd user also has access to 
#         Tor's ControlPort.
# v0.0.1: Basic stupid firewall.
#
##############################################################################
## VARIABLES
##############################################################################

REVERSE_PATH_FILTER=false

TOR_RELAY=false
TOR_OR_PORT="9001"
TOR_OR_ALT_PORT="9090"

TOR_CLIENT=true
TOR_SOCKS_PORT="59050"
#TOR_SOCKS_ALT_PORT="9050"
TOR_CONTROL_PORT="9051"

TRANSPROXY=true
TOR_TRANS_PORT="9040"
TOR_DNS_PORT="5353"
TRANSPROXY_USER=anon

SSH=true
SSH_PORT="22"
SSH_ALT_PORT="2222"
MOSH=true
MOSH_PORTS="60000:61000"

TAHOE=true
TAHOE_PORT="3456"

DHCP=true
DHCP_PORT="67"
DHCP_PORT2="68"

SMTP_PORT="25"

RPCBIND_PORT="111"
RPCBIND_PORT2="33939"

CUPS_PORT="631"

MPD_PORT="6600"

ALLOW_BITTORRENT=false
BITTORRENT_TRACKER="6881"

## UNCOMMENT THE FOLLOWING IF YOUR VPS PROVIDER MAKES YOU BLOCK BITTORRENT
## OVER TOR (OR TELL THEM TO EAT SNOT): NOTE: This doesn't *actually* block
## bittorrents, just the standard ports for the trackers. Anyone can tell
## their bittorrent client to connect on a different port, even encrypted over
## port 80. But this makes it look like you're trying to comply.

#BITTORRENT_RANGE="6881-6889"
#BITTORRENT_PORT="2710"
#BITTORRENT_PORT2="6969"

##############################################################################
## FLUSHING AND DEFAULT POLICIES
##############################################################################

## FLUSH OLD RULES
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t raw -F

## FLUSH ANY USER-DEFINED TABLES
sudo iptables -X
sudo iptables -t nat -X
sudo iptables -t raw -X

## SET SECURE DEFAULT POLICIES
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

## XXX TODO: Should we change OUTPUT policy to DROP and implement whitelist 
## rules to (slightly) mitigate reverse shellcode?

##############################################################################
## REVERSE PATH FILTER
## -------------------
## If a reply to the packet would be sent via the same interface that the 
## packet arrived on, the packet will pass. Loopback is always allowed, and
## the IP address of the local machine is also allowed, regardless of 
## interface transversal.
##############################################################################

if $REVERSE_PATH_FILTER ; then
    sudo iptables -t raw -N RPFILTER
    sudo iptables -t raw -A RPFILTER -m rpfilter --accept-local -j RETURN
    sudo iptables -t raw -A RPFILTER -m limit --limit 1/min -j LOG --log-prefix "iptables: rpfilter: " --log-level 7
    sudo iptables -t raw -A RPFILTER -j DROP
    sudo iptables -t raw -A PREROUTING -j RPFILTER
fi

##############################################################################
## DROP COMMON EXPLOITATION, DOS, AND SCANNING PACKETS
##############################################################################

## DROP INVALID
sudo iptables -A INPUT -m state --state INVALID -j LOG --log-prefix "iptables: INVALID packet: " --log-level 7
sudo iptables -A INPUT -m state --state INVALID -j DROP

## DROP INVALID SYN PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j LOG --log-prefix "iptables: (ACK,RST,SYN,FIN): " --log-level 7
sudo iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP

sudo iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOG --log-prefix "iptables: TCP (SYN,FIN): " --log-level 7
sudo iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP

sudo iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "iptables: TCP (SYN,RST): " --log-level 7
sudo iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

## DROP PACKETS WITH INCOMING FRAGMENTS. THIS ATTACK ONCE RESULTED IN KERNEL PANICS
sudo iptables -A INPUT -f -j LOG --log-prefix "iptables: fragmented: " --log-level 7
sudo iptables -A INPUT -f -j DROP

## DROP INCOMING XMAS PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "iptables: XMAS packet: " --log-level 7
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

## DROP INCOMING NULL PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "iptables: NULL packet: " --log-level 7
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

##############################################################################
## INPUT
## -----
## Note: For TCP traffic, the "--reject-with tcp-reset" option should be used
##       because networks scanners with any brains to them detect rejected and
##       dropped packets as a sign of a filtered port. A truly closed port
##       will gracefully respond with a RST, so we'll mimic that behaviour to
##       appear closed.
##############################################################################

## BLOCK INCOMING SMTP TRAFFIC ON PORT 25
if test -n "$SMTP_PORT"; then
    sudo iptables -A INPUT -p tcp --dport $SMTP_PORT -m limit --limit 5/min --limit-burst 50 -j LOG --log-prefix "iptables: SMTP: " --log-level 7
    sudo iptables -A INPUT -p tcp --dport $SMTP_PORT -j REJECT --reject-with tcp-reset
fi

## BLOCK RPCBIND FOR TCP AND UDP
if test -n "$RPCBIND_PORT"; then
    sudo iptables -A INPUT -p tcp --dport $RPCBIND_PORT -m limit --limit 1/min --limit-burst 10 -j LOG --log-prefix "iptables: RPCBIND: " --log-level 7
    sudo iptables -A INPUT -p tcp --dport $RPCBIND_PORT -j REJECT --reject-with tcp-reset
    sudo iptables -A INPUT -p udp --dport $RPCBIND_PORT -j DROP
fi

if test -n "$RPCBIND_PORT2"; then
    sudo iptables -A INPUT -p tcp --dport $RPCBIND_PORT2 -m limit --limit 1/min --limit-burst 10 -j LOG --log-prefix "iptables: RPCBIND: " --log-level 7
    sudo iptables -A INPUT -p tcp --dport $RPCBIND_PORT2 -j REJECT --reject-with tcp-reset
    sudo iptables -A INPUT -p udp --dport $RPCBIND_PORT2 -j DROP
fi

## BLOCK CUPS (COMMENT OUT OR SET $CUPS_PORT="" BEFORE PRINTING)
if test -n "$CUPS_PORT"; then
    sudo iptables -A INPUT -p tcp --dport $CUPS_PORT -m limit --limit 2/min --limit-burst 25 -j LOG --log-prefix "iptables: CUPS: " --log-level 7
    sudo iptables -A INPUT -p tcp --dport $CUPS_PORT -j REJECT --reject-with tcp-reset
fi

## REJECT MPD ACCESS FOR EVERYONE EXCEPT LOCALHOST
if test -n "$MPD_PORT"; then
    #sudo iptables -A INPUT -p tcp -s localhost --dport $MPD_PORT -j REJECT --reject-with tcp-reset
    sudo iptables -A INPUT ! -i lo -p tcp --dport $MPD_PORT -m limit --limit 1/min --limit-burst 10 -j LOG --log-prefix "iptables: MPD: " --log-level 7
    sudo iptables -A INPUT ! -i lo -p tcp --dport $MPD_PORT -j REJECT --reject-with tcp-reset
fi

if $TOR_CLIENT ; then
    ## REJECT SocksPort REQUESTS FOR ALL EXCEPT LOCALHOST 
    ## Tor does this by default, but just to be extra sure...
    if test -n "$TOR_SOCKS_PORT"; then
        sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_SOCKS_PORT -j LOG --log-prefix "iptables: Tor SocksPort: " --log-level 7
        sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_SOCKS_PORT -j REJECT --reject-with tcp-reset
    fi

    if test -n "$TOR_SOCKS_ALT_PORT"; then
        sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_SOCKS_ALT_PORT -j LOG --log-prefix "iptables: Tor SocksAltPort: " --log-level 7
        sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_SOCKS_ALT_PORT -j REJECT --reject-with tcp-reset
    fi

    ## REJECT Tor ControlPort REQUESTS FOR ALL EXCEPT LOCALHOST
    if test -n "$TOR_CONTROL_PORT"; then
        sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_CONTROL_PORT -j LOG --log-prefix "iptables: Tor ControlPort: " --log-level 7
        sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_CONTROL_PORT -j REJECT --reject-with tcp-reset
    fi
fi

if $TOR_RELAY ; then
    if test -n "$TOR_OR_PORT"; then
        sudo iptables -A INPUT -p tcp --dport $TOR_OR_PORT -j ACCEPT
    fi

    if test -n "$TOR_OR_ALT_PORT"; then
        sudo iptables -A INPUT -p tcp --dport $TOR_OR_ALT_PORT -j ACCEPT
    fi
fi

## ACCEPT LOOPBACK, REJECT ACCESS TO LOCALHOST FROM ALL BUT LOOPBACK (And
## bridge)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -i br0 -j ACCEPT
## LOG AND REJECT NON-LOCALHOST LOOPBACK TRAFFIC
sudo iptables -A INPUT ! -i lo -d 127.0.0.1/8 -j LOG --log-prefix "iptables: !localhost to lo: " --log-level 7
sudo iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

## ACCEPT ESTABLISHED AND RELATED TRAFFIC
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


if $SSH ; then
    ## ALLOW SSH (AND MOSH!)
    if test -n "$SSH_PORT"; then
        sudo iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED --dport $SSH_PORT -j ACCEPT
        ## XXX the UDP might not be needed since MOSH does a handshake/keyexchange first over TCP
        sudo iptables -A INPUT -p udp --dport $SSH_PORT -j ACCEPT
    fi

    if test -n "$SSH_ALT_PORT"; then
        sudo iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED --dport $SSH_ALT_PORT -j ACCEPT
        ## XXX the UDP might not be needed since MOSH does a handshake/keyexchange first over TCP
        sudo iptables -A INPUT -p udp --dport $SSH_ALT_PORT -j ACCEPT
    fi

    if $MOSH ; then
        sudo iptables -A INPUT -p udp --dport $MOSH_PORTS -j ACCEPT
    fi
fi 

## Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

## Allow Bittorrent peers to connect to us
if $ALLOW_BITTORRENT ; then
    sudo iptables -A INPUT -p tcp --dport $BITTORRENT_TRACKER -j ACCEPT
fi

## Allow Tahoe-LAFS connections
if $TAHOE ; then
    sudo iptables -A INPUT -p tcp --dport $TAHOE_PORT -j ACCEPT
fi

## Allow DHCP for the local network, if you're okay with that piece of shit
if $DHCP ; then
    sudo iptables -A INPUT -p udp --dport $DHCP_PORT -j ACCEPT
    sudo iptables -A INPUT -p udp --dport $DHCP_PORT2 -j ACCEPT
fi

##############################################################################
## TRANSPROXY CONFIGURATION
##############################################################################
## ICMP SETTINGS
## -------------
## Due to non-ownership, correlations could be made between Tor DNS requests
## and non-Tor DNS requests, so TransProxy'd users should avoid outgoing
## pinging.
##

## BLOCK INCOMING ICMP PINGS:
## Destination-unreachable(3), source-quench(4) and time-exceeded(11) are
## required:
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 3 -j ACCEPT
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 4 -j ACCEPT
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 11 -j ACCEPT

## For ping and traceroute you want echo-request(8) and echo-reply(0) enabled:
## You might be able to disable them, but it would probably break things.
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

## REJECT ALL OTHER ICMP TYPES:
sudo iptables -A INPUT -p icmp -m limit --limit 10/min --limit-burst 1000 -j LOG --log-prefix "iptables: ICMP !0/3/4/8/11: " --log-level 7 
sudo iptables -A INPUT -p icmp -j REJECT --reject-with icmp-host-unreachable

## TO GLOBALLY BLOCK OUTGOING PINGS, FOR Tor TransProxy, UNCOMMENT THE
## FOLLOWING:
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 3 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 4 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 11 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -j REJECT --reject-with icmp-host-unreachable

## ----------------
## TCP/UDP SETTINGS
## ----------------
if $TRANSPROXY ; then
    ## ALLOW ANONYMOUS USER ACCESS TO Tor's ControlPort:
    if test -n "$TOR_CONTROL_PORT"; then
        sudo iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner $TRANSPROXY_USER -m tcp --syn -d 127.0.0.1 --dport $TOR_CONTROL_PORT -j ACCEPT
    fi

    ## REDIRECT NON-LOOPBACK TCP TO TransPort:
    if test -n "$TOR_TRANS_PORT"; then
        sudo iptables -t nat -A OUTPUT ! -o lo -p tcp -m owner --uid-owner $TRANSPROXY_USER -m tcp -j REDIRECT --to-ports $TOR_TRANS_PORT
    fi

    ## REDIRECT NON-LOOPBACK DNS TO DNSPort:
    if test -n "$TOR_DNS_PORT"; then
        sudo iptables -t nat -A OUTPUT ! -o lo -p udp -m owner --uid-owner $TRANSPROXY_USER -m udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
        ## AND THEN ALLOW THE TOR_DNS_PORT:
        sudo iptables -A INPUT -p udp --dport $TOR_DNS_PORT -j ACCEPT
        sudo iptables -A INPUT -p udp --sport $TOR_DNS_PORT -j ACCEPT
    fi

    ## ACCEPT OUTGOING TRAFFIC FOR ANONYMOUS ONLY FROM THE TransPort AND
    ## DNSPort:
    if test -n "$TRANSPROXY_USER"; then
        sudo iptables -t filter -A OUTPUT -p tcp -m owner --uid-owner $TRANSPROXY_USER -m tcp --dport $TOR_TRANS_PORT -j ACCEPT
        sudo iptables -t filter -A OUTPUT -p udp -m owner --uid-owner $TRANSPROXY_USER -m udp --dport $TOR_DNS_PORT -j ACCEPT

    ## DROP ALL OTHER TRAFFIC FOR USER ANONYMOUS:
        sudo iptables -t filter -A OUTPUT -m owner --uid-owner $TRANSPROXY_USER -j LOG --log-prefix "iptables: TransProxy: " --log-level 7
        sudo iptables -t filter -A OUTPUT -m owner --uid-owner $TRANSPROXY_USER -j DROP
    fi
fi

##############################################################################
## LOGS
##############################################################################

## Log iptables calls
#sudo iptables -A INPUT -m limit --limit 1000/sec -j LOG --log-prefix "iptables: " --log-level 7

##############################################################################
## FIN
##############################################################################

## REJECT ANYTHING NOT ALLOWED ABOVE:
sudo iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
sudo iptables -A INPUT -j REJECT

sudo iptables -A FORWARD -p tcp -j REJECT --reject-with tcp-reset
sudo iptables -A FORWARD -j REJECT



