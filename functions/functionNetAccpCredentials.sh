#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for the accespoint credentials and write it -
###       back as a variable.
###       It will write back the values to the corresponding netctl configuration files.
function functionNetAccpCredentials {
  echo "####################################################################################"
  echo "Enter the credentials for your accesspoint"
  echo "####################################################################################"
    read -p 'Enter wifi name (Accesspoint): ' wifiAp
    read -p 'Enter wifi password: ' wifiKey

  echo "Prepping WiFi netctl config files"
    sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAp'/" /temp/root/etc/netctl/wlan0
    sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
}
