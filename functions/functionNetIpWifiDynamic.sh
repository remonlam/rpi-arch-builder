#!/bin/bash

#########################################################################################
### NOTE: This function will write netctl configuration files when using WiFi.
###
### NOTE: This function is used only for Wifi
function functionNetIpWifiDynamic {
  echo "Setup Dynamic IP settings for: $varIpType"
  echo "#########################################################################"

# Downloading netctl template files and wpa packages
  {
  # Download "libnl" and "wpa_supplicant" package tar.gz file from GitHub
    cp -rf packages/libnl-3.4.0-1-aarch64.pkg.tar.xz /temp/
  # Extract tar.gz file to root/
    tar -xf /temp/libnl-3.4.0-1-aarch64.pkg.tar.xz -C /temp/root/
  # Copy netctl wlan0 config file
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/wlan0
    cp -rf /temp/wlan0 /temp/root/etc/netctl/
  # Copy wlan0.service file to systemd and create symlink to make it work at first boot
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40wlan0.service
    cp -rf /temp/netctl@wlan0.service /temp/root/etc/systemd/system/
    ln -s '/temp/root/etc/systemd/system/netctl@wlan0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@wlan0.service'
  } &> /dev/null
}
