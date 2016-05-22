#!/bin/sh

### SCRIPT VARIABLES
## Ask user for system specific variables
read -s -p 'Enter Root password: ' systemRootPassword


# Network variables
#networkHostname=
#networkIp=
#networkSubnet=24
#networkGateway=192.168.0.1
#networkDns1=192.168.0.100
#networkDns2=192.168.0.200
#networkDnsSearch=domain.local
networkDevice=eth0 # This is the default LAN port on the raspbeery Pi, if you're using WiFi use wlan0

# System Variables
#systemRootPassword=P@ssword,

# Time servicess
# Note: uses the Dutch time server
systemNtp0=0.nl.pool.ntp.org
systemNtp1=1.nl.pool.ntp.org
systemNtp2=2.nl.pool.ntp.org
systemNtp3=3.nl.pool.ntp.org


##	Configure networking

# Configure networking on eth0 with a static IP:
#echo -e "Description='Network - $networkDevice'\nInterface=$networkDevice\nConnection=ethernet\nIP=static\nAddress=('$networkIp/$networkSubnet')\nGateway=('$networkGateway')\nDNS=('$networkDns1' '$networkDns2')" > /etc/netctl/eth0

# Enable the new interface so it starts the next time the system boots:
#netctl enable $networkDevice

# Stoping all unwanted network related services, because we configured the config file in /etc/netctl/eth0:
#systemctl stop systemd-networkd.service
#systemctl disable systemd-networkd.service
#systemctl stop systemd-resolved.service
#systemctl disable systemd-resolved.service

# Remove the old /etc/resolv.conf, otherwise we can't populate it:
#rm /etc/resolv.conf

# Populate /etc/resolv.conf with new dns servers:
#echo -e "search $networkDnsSearch\nnameserver $networkDns1\nnameserver $networkDns2" > /etc/resolv.conf

# Sets hostname to pi-n1:
#echo $networkHostname > /etc/hostname

# Fill the hostfile with local cluster Pi nodes:
#echo -e "127.0.0.1 localhost.localdomain localhost\n10.100.10.120 pi-n0.domain.local pi-n0\n10.100.10.121 pi-n1.domain.local pi-n1\n10.100.10.122 pi-n2.domain.local pi-n2\n10.100.10.123 pi-n3.domain.local pi-n3" > /etc/hosts


##	Configure system

# Time zone configuration, sets it to Europe/Amsterdam:
timedatectl set-timezone Europe/Amsterdam

# Populate NTP source file "etc/systemd/timesyncd.conf":
echo -e "NTP=$systemNtp0 $systemNtp1 $systemNtp2 $systemNtp3" > /etc/systemd/timesyncd.conf

# Check if everything configured correctly, and check the system time using "date":
#timedatectl status
#date

# Sets root password to what the user has filled in:
echo root:$systemRootPassword | chpasswd

# Remove all SSH keys:
rm -f /etc/ssh/ssh_host_dsa_key
rm -f /etc/ssh/ssh_host_rsa_key

# Generate new SSH keys:
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N "" -t dsa
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa


# Disable X interface, so we only have cli, this saves memory which is good because it is limited:
systemctl set-default multi-user.target

# Check if it's configured correctly:
systemctl get-default


# Update repositories in oder to download docker:
pacman --noconfirm -Sy

# Install all required packages
pacman -S --noconfirm wget nano vi net-tools iftop iotop tar zip

echo "Would you like to install Docker on this system?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 	pacman -S --noconfirm docker
		systemctl enable docker
		systemctl start docker; break;;
        No ) exit;;
    esac
done

# Update Arch Linux:
pacman --noconfirm -Syu

# Ask user to reboot the system, if true then reboot system:
echo "The system has been updated and needs to be rebooted, do you want to reboot right now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) reboot; break;;
        No ) exit;;
    esac
done
