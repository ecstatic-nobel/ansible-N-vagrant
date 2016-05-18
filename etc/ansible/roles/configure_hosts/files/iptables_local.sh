#!/bin/bash

ip6tables -F
ip6tables -X

ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

iptables -A INPUT -s 0/0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

iptables -N INITIAL_SSH
iptables -A INPUT -s 0/0 -p tcp --syn --dport 22 -j INITIAL_SSH
iptables -A INITIAL_SSH -m recent --name TRAP_SSH --rcheck --seconds 60 --hitcount 3 --rttl -j DROP
iptables -A INITIAL_SSH -m recent --name TRAP_SSH --set -j RETURN

iptables -N THROTTLE_SSH
iptables -A INPUT -s 0/0 -p tcp --syn --dport 22 -j THROTTLE_SSH
iptables -A THROTTLE_SSH -m connlimit --connlimit-above 3 -j DROP
iptables -A THROTTLE_SSH -m limit --limit 1/m --limit-burst 3 -j ACCEPT
