#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for Static IP configuration and write -
###       it back as a variable.
###
### NOTE: This function is used only for WiFi
function functionNetIpWifiStatic {
  echo "Setup Fixed IP settings for WiFi: $varIpType"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' wifiIp
    read -p 'Enter IP Subnet, example: 24: ' wifiMask
    read -p 'Enter Gateway: ' wifiGateway
    read -p 'Enter DNS 1: ' wifiDns1
    read -p 'Enter DNS 2: ' wifiDns2
    read -p 'Enter DNS Search domain: ' dnsSearch

# Downloading netctl template files and wpa packages
  {
  # Download "libnl" and "wpa_supplicant" package tar.gz file from GitHub
    wget -P /temp/ https://github.com/remonlam/rpi-zero-arch/raw/master/packages/libnl_wpa_package.tar.gz
  # Extract tar.gz file to root/
    tar -xf /temp/libnl_wpa_package.tar.gz -C /temp/root/
  # Copy netctl wlan0 config file
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/wlan0
    cp -rf /temp/wlan0 /temp/root/etc/netctl/
  # Copy wlan0.service file to systemd and create symlink to make it work at first boot
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40wlan0.service
    cp -rf /temp/netctl@wlan0.service /temp/root/etc/systemd/system/
    ln -s '/temp/root/etc/systemd/system/netctl@wlan0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@wlan0.service'
  } &> /dev/null

# Prepping Ethernet configuration files
  echo "Prepping WiFi netctl config files"
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$wifiIp/$wifiMask')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$wifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$wifiDns1' '$wifiDns2')" /temp/root/etc/netctl/wlan0
}
