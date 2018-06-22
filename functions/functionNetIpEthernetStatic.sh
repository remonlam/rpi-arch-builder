#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for Static IP configuration and write -
###       it back as a variable.
###
### NOTE: This function is used only for Ethernet
function functionNetIpEthernetStatic {
  echo "Setup Fixed IP settings for Ethernet: $varIpType"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' ethernetIp
    read -p 'Enter IP Subnet, example: 24: ' ethernetMask
    read -p 'Enter Gateway: ' ethernetGateway
    read -p 'Enter DNS 1: ' ethernetDns1
    read -p 'Enter DNS 2: ' ethernetDns2
    read -p 'Enter DNS Search domain: ' dnsSearch

# Downloading netctl template files
  {
  # Copy netctl eth0 config file
    cp -rf ../sources/eth0.network /temp/etc/systemd/network/
    #cp -rf /temp/netctl@eth0.service /temp/root/etc/systemd/system/
  # Copy wlan0.service file to systemd and create symlink to make it work at first boot
    cp --rf ../sources/wlan0.network /temp/etc/systemd/network/
    #cp -rf /temp/netctl@eth0.service /temp/root/etc/systemd/system/
    #ln -s '/temp/root/etc/systemd/system/netctl@eth0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@eth0.service'
  } &> /dev/null

# Prepping Ethernet configuration files
  echo "Prepping Ethernet netctl config files"
    sed -i "s/NETIP/$ethernetIp/" /temp/root/etc/systemd/network/eth0.network
    sed -i "s/NETSUB/$ethernetMask/" /temp/root/etc/systemd/network/eth0.network
    sed -i "s/NETGW/$ethernetGateway/" /temp/root/etc/systemd/network/eth0.network
    sed -i "s/NETDNS1/$ethernetDns1/" /temp/root/etc/systemd/network/eth0.network
    sed -i "s/NETDNS2/$ethernetDns2/" /temp/root/etc/systemd/network/eth0.network

 # Remove "systemd-networkd.service"
    #rm -rf /temp/root/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
    #rm -rf /temp/root/etc/systemd/system/socket.target.wants/systemd-networkd.service
}


##### TEMP STUFF
#/etc/systemd/network/eth0.network

#Address=IPSUB
#Gateway=GW
#DNS=8.8.8.8
#DNS=8.8.4.4
