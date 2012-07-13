#!/bin/bash
####################################################################################
# TOR RELAY IPTABLES FIREWALL
####################################################################################
# For use on a Tor Relay with an optional TransProxy'd anonymous user.
#
# @author Isis Lovecruft, 0x2cdb8b35
# @version 0.0.3
# @license CC BY-NC-SA 3.0
#___________________________________________________________________________________
#
# Changelog:
#
# v0.0.3: Added incoming POP3/IMAP/S port blocking, FTP/S blocking, and sadly,
#         optional incoming/outgoing Bittorrent blocking to keep asshole ISPs happy.
# v0.0.2: Added TransProxy user rules. TransProxy'd user also has access to Tor's
#         ControlPort.
# v0.0.1: Basic stupid firewall.
#
####################################################################################
## VARIABLES
####################################################################################
TOR_OR_PORT="9001"
TOR_DIR_PORT="9030"

TOR_SOCKS_PORT="9050"
TOR_SOCKS_ALT_PORT="9666"
TOR_CONTROL_PORT="9051"

## Set to true to set up a Transparent Proxy for all traffic for $TRANSPROXY_USER.
## see https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy
TRANSPROXY=false
TOR_TRANS_PORT="9040"
TOR_DNS_PORT="5353"
TRANSPROXY_USER="anonymous"

SSH_PORT="22"
SSH_ALT_PORT="2222"

## Set to true to allow Mosh connections. See https://mosh.mit.edu/
MOSH=false
MOSH_PORTS="60000:61000"

NOT_AN_FTP_SERVER=true
FTP_PORT="21"
FTPS_DATA_PORT="989"
FTPS_CONTROL_PORT="990"

NOT_A_MAIL_SERVER=true
SMTP_PORT="25"
SMTP_ALT_PORT="465"
POP3_PORT="110"
POP3S_PORT="995"
IMAP_PORT="143"
IMAPS_PORT="993"

RPCBIND_PORT="111"
#RPCBIND_PORT2="35996"

LOCALHOST_ACCESS_ONLY_PORT="8080"

## UNCOMMENT THE FOLLOWING IF YOUR VPS PROVIDER MAKES YOU BLOCK BITTORRENT OVER TOR:
## NOTE: This doesn't *actually* block bittorrents, just the standard ports for the 
## trackers. Anyone can tell their bittorrent client to connect on a different port,
## even encrypted over port 80. But this makes it look like you're trying to comply.
#FUCK_MY_ISP=true
#BITTORRENT_RANGE="6881-6889"
#XBT_TRACKER_PORT="2710"
#BITTORRENT_TRACKER_PORT="6969"

####################################################################################
## FLUSHING AND DEFAULT POLICIES
####################################################################################
## FLUSH OLD RULES
sudo iptables -F
sudo iptables -t nat -F
## FLUSH ANY USER-DEFINED TABLES
sudo iptables -X

## SET SECURE DEFAULT POLICIES
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

## XXX TODO: Should we change OUTPUT policy to DROP and implement whitelist rules
##           to (slightly) mitigate reverse shellcode?

####################################################################################
## DROP COMMON EXPLOITATION, DOS, AND SCANNING PACKETS
####################################################################################
## DROP INVALID
sudo iptables -A INPUT -m state --state INVALID -j DROP

## DROP INVALID SYN PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

## DROP PACKETS WITH INCOMING FRAGMENTS. THIS ATTACK ONCE RESULTED IN KERNEL PANICS
sudo iptables -A INPUT -f -j DROP

## DROP INCOMING XMAS PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

## DROP INCOMING NULL PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

####################################################################################
## INPUT
####################################################################################
## Note: For TCP traffic, the "--reject-with tcp-reset" option should be used because
##       networks scanners with any brains to them detect rejected and dropped packets
##       as a sign of a filtered port. A truly closed port will gracefully respond 
##       with a RST, so we'll mimic that behaviour to appear closed.
####################################################################################

## ACCEPT LOOPBACK, REJECT ACCESS TO LOCALHOST FROM ALL BUT LOOPBACK
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

## ACCEPT ESTABLISHED AND RELATED TRAFFIC
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## If it's 'true' that we are $NOT_A_MAIL_SERVER, then we should not allow these
## services. Note that outgoing traffic on these ports is still allowed, so this
## does not affect the Tor relay.
if $NOT_A_MAIL_SERVER ; then

    if [[ "$SMTP_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $SMTP_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$SMTP_ALT_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $SMTP_ALT_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$POP3_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $POP3_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$POP3S_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $POP3S_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$IMAP_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $IMAP_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$IMAPS_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $IMAPS_PORT -j REJECT --reject-with tcp-reset
    fi
fi

## If it's 'true' that we are $NOT_AN_FTP_SERVER, then we should not allow these
## services. Note that outgoing traffic on these ports is still allowed, so this
## does not affect the Tor relay.
if $NOT_AN_FTP_SERVER ; then

    if [[ "$FTP_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $FTP_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$FTPS_DATA_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $FTPS_DATA_PORT -j REJECT --reject-with tcp-reset
    fi

    if [[ "$FTPS_CONTROL_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $FTPS_CONTROL_PORT -j REJECT --reject-with tcp-reset
    fi
fi

## If your ISP/VPS provider asks you to...make it look like you're complying
if $FUCK_MY_ISP ; then

    if [[ "$BITTORRENT_RANGE" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $BITTORRENT_RANGE -j REJECT --reject-with tcp-reset
        sudo iptables -A INPUT -p udp --dport $BITTORRENT_RANGE -j DROP
        sudo iptables -A OUTPUT -p tcp --dport $BITTORRENT_RANGE -j REJECT --reject-with tcp-reset
        sudo iptables -A OUTPUT -p udp --dport $BITTORRENT_RANGE -j DROP
    fi

    if [[ "$XBT_TRACKER_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $XBT_TRACKER_PORT -j REJECT --reject-with tcp-reset
        sudo iptables -A INPUT -p udp --dport $XBT_TRACKER_PORT -j DROP
        sudo iptables -A OUTPUT -p tcp --dport $XBT_TRACKER_PORT -j REJECT --reject-with tcp-reset
        sudo iptables -A OUTPUT -p udp --dport $XBT_TRACKER_PORT -j DROP
    fi

    if [[ "$BITTORRENT_TRACKER_PORT" != "" ]]; then
        sudo iptables -A INPUT -p tcp --dport $BITTORRENT_TRACKER_PORT -j REJECT --reject-with tcp-reset
        sudo iptables -A INPUT -p udp --dport $BITTORRENT_TRACKER_PORT -j DROP
        sudo iptables -A OUTPUT -p tcp --dport $BITTORRENT_TRACKER_PORT -j REJECT --reject-with tcp-reset
        sudo iptables -A OUTPUT -p udp --dport $BITTORRENT_TRACKER_PORT -j DROP
    fi
fi

## BLOCK RPCBIND FOR TCP AND UDP
if [[ "$RPCBIND_PORT" != "" ]]; then
    sudo iptables -A INPUT -p tcp --dport $RPCBIND_PORT -j REJECT --reject-with tcp-reset
    sudo iptables -A INPUT -p udp --dport $RPCBIND_PORT -j DROP
fi

if [[ "$RPCBIND_PORT2" != "" ]]; then
    sudo iptables -A INPUT -p tcp --dport $RPCBIND_PORT2 -j REJECT --reject-with tcp-reset
    sudo iptables -A INPUT -p udp --dport $RPCBIND_PORT2 -j DROP
fi

## REJECT ACCESS FOR EVERYONE EXCEPT LOCALHOST
if [[ "$LOCALHOST_ACCESS_ONLY_PORT" != "" ]]; then
    sudo iptables -A INPUT ! -i lo -p tcp --dport $LOCALHOST_ACCESS_ONLY_PORT -j REJECT --reject-with tcp-reset
fi

## REJECT SocksPort REQUESTS FOR ALL EXCEPT LOCALHOST 
## Tor does this by default, but just to be extra sure...
if [[ "$TOR_SOCKS_PORT" != "" ]]; then
    sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_SOCKS_PORT -j REJECT --reject-with tcp-reset
fi

if [[ "$TOR_SOCKS_ALT_PORT" != "" ]]; then
    sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_SOCKS_ALT_PORT -j REJECT --reject-with tcp-reset
fi

## REJECT Tor ControlPort REQUESTS FOR ALL EXCEPT LOCALHOST
if [[ "$TOR_CONTROL_PORT" != "" ]]; then
    sudo iptables -A INPUT ! -i lo -p tcp --dport $TOR_CONTROL_PORT -j REJECT --reject-with tcp-reset
fi

## ALLOW Tor DirPort AND ORPort
if [[ "$TOR_OR_PORT" != "" ]]; then
    sudo iptables -A INPUT -p tcp --dport $TOR_OR_PORT -j ACCEPT
fi

if [[ "$TOR_DIR_PORT" != "" ]]; then
    sudo iptables -A INPUT -p tcp --dport $TOR_DIR_PORT -j ACCEPT
fi

## ALLOW SSH (AND MOSH!)
if [[ "$SSH_PORT" != "" ]]; then
    sudo iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED --dport $SSH_PORT -j ACCEPT
    ## XXX the UDP might not be needed since MOSH does a handshake/keyexchange first over TCP
    sudo iptables -A INPUT -p udp --dport $SSH_PORT -j ACCEPT
fi

if [[ "$SSH_ALT_PORT" != "" ]]; then
    sudo iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED --dport $SSH_ALT_PORT -j ACCEPT
    ## XXX the UDP might not be needed since MOSH does a handshake/keyexchange first over TCP
    sudo iptables -A INPUT -p udp --dport $SSH_ALT_PORT -j ACCEPT
fi

if $MOSH ; then
    sudo iptables -A INPUT -p udp --dport $MOSH_PORTS -j ACCEPT
fi

## Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

####################################################################################
## TRANSPROXY CONFIGURATION
####################################################################################
## ICMP SETTINGS
## -------------
## Due to non-ownership, correlations could be made between Tor DNS requests and 
## non-Tor DNS requests, so TransProxy'd users should avoid outgoing pinging.
##
## BLOCK INCOMING ICMP PINGS:
## Destination-unreachable(3), source-quench(4) and time-exceeded(11) are required:
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 3 -j ACCEPT
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 4 -j ACCEPT
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 11 -j ACCEPT

## For ping and traceroute you want echo-request(8) and echo-reply(0) enabled:
## You might be able to disable them, but it would probably break things.
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

## REJECT ALL OTHER ICMP TYPES:
sudo iptables -A INPUT -p icmp -j REJECT

## TO GLOBALLY BLOCK OUTGOING PINGS, FOR Tor TransProxy, UNCOMMENT THE FOLLOWING:
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 3 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 4 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 11 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT
#sudo iptables -A OUTPUT -p icmp -j REJECT

## ----------------
## TCP/UDP SETTINGS
## ----------------
if $TRANSPROXY ; then
    if [[ "$TRANSPROXY_USER" != "" ]]; then

        ## ALLOW ANONYMOUS USER ACCESS TO Tor's ControlPort:
        if [[ "$TOR_CONTROL_PORT" != "" ]]; then
            sudo iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner $TRANSPROXY_USER -m tcp --syn -d 127.0.0.1 --dport $TOR_CONTROL_PORT -j ACCEPT
        fi

        ## REDIRECT NON-LOOPBACK TCP TO TransPort:
        if [[ "$TOR_TRANS_PORT" != "" ]]; then
            sudo iptables -t nat -A OUTPUT ! -i lo -p tcp -m owner --uid-owner $TRANSPROXY_USER -m tcp -j REDIRECT --to-ports $TOR_TRANS_PORT
        fi

         ## REDIRECT NON-LOOPBACK DNS TO DNSPort:
        if [[ "$TOR_DNS_PORT" != "" ]]; then
            sudo iptables -t nat -A OUTPUT ! -i lo -p udp -m owner --uid-owner $TRANSPROXY_USER -m udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
        fi

        ## ACCEPT OUTGOING TRAFFIC FOR ANONYMOUS ONLY FROM THE TransPort AND DNSPort:
        if [[ "$TOR_TRANS_PORT" != "" ]]; then
            sudo iptables -t filter -A OUTPUT -p tcp -m owner --uid-owner $TRANSPROXY_USER -m tcp --dport $TOR_TRANS_PORT -j ACCEPT
        fi

        if [[ "$TOR_DNS_PORT" != "" ]]; then
            sudo iptables -t filter -A OUTPUT -p udp -m owner --uid-owner $TRANSPROXY_USER -m udp --dport $TOR_DNS_PORT -j ACCEPT
        fi

        ## DROP ALL OTHER TRAFFIC FOR USER ANONYMOUS:
        sudo iptables -t filter -A OUTPUT -m owner --uid-owner $TRANSPROXY_USER -j DROP
    fi
fi

####################################################################################
## LOGS
####################################################################################
## Log iptables denied calls
sudo iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

####################################################################################
## FIN
####################################################################################
## REJECT ANYTHING NOT ALLOWED ABOVE:
sudo iptables -A INPUT -j REJECT
sudo iptables -A FORWARD -j REJECT