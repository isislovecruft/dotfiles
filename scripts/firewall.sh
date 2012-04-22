#!/bin/bash
#
# Basic iptables firewall

## Flush old rules
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -X

## Set secure defaults
sudo iptables -P INPUT DROP
## FORWARD rules does not actually do anything if forwarding is disabled. Better be safe just in case.
sudo iptables -P FORWARD DROP
## Since Tor-Gateway is trusted we can allow outgoing traffic from it.
sudo iptables -P OUTPUT ACCEPT

## DROP INVALID
sudo iptables -A INPUT -m state --state INVALID -j DROP

## DROP INVALID SYN PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

## DROP PACKETS WITH INCOMING FRAGMENTS. THIS ATTACK ONCE RESULTED IN KERNEL PANICS
sudo iptables -A INPUT -f -j DROP

## DROP INCOMING MALFORMED XMAS PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

## DROP INCOMING MALFORMED NULL PACKETS
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

## FUCK YOU, EXIM SMTP
sudo iptables -A INPUT -p tcp --dport 25 -j REJECT --reject-with tcp-reset

## AND FUCK YOU, CUPS
sudo iptables -A INPUT -p tcp --dport 631 -j REJECT --reject-with tcp-reset

## ALSO, FUCK YOU RPCBIND
sudo iptables -A INPUT -p tcp --dport 111 -j REJECT --reject-with tcp-reset
sudo iptables -A INPUT -p udp --dport 111 -j DROP
sudo iptables -A INPUT -p tcp --dport 35996 -j REJECT --reject-with tcp-reset
sudo iptables -A INPUT -p udp --dport 35996 -j DROP

## Reject MPD access for everyone but localhost
sudo iptables -A INPUT ! -i lo -p tcp --dport 6600 -j REJECT --reject-with tcp-reset

## Accept established traffic
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## Traffic on the loopback interface is accepted.
sudo iptables -A INPUT -i lo -j ACCEPT

## Reject anything not allowed above
sudo iptables -A INPUT -j REJECT
sudo iptables -A FORWARD -j REJECT