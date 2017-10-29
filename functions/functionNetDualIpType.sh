#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for DHCP or Static IP configuraton and write -
###       it back as a variable.
###
### NOTE: This function is used when a user want's to use both WiFi and Ethernet.
function functionNetDualIpType {
  echo "###########################################################################################"
  echo "Both WiFI and Ethernet needs to be configurd, please select the required IP configuration;"
  echo "###########################################################################################"
    select yn in "WiFi: DHCP & Eth: DHCP" "WiFi: DHCP & Eth: Static" "WiFi: Static & Eth: DHCP" "WiFi: Static & Eth: Static" "Exit"; do
      case $yn in
        'WiFi: DHCP & Eth: DHCP' ) varIpType="$varNetworkType-DHCP_DHCP"; break;;
        'WiFi: DHCP & Eth: Static' ) varIpType="$varNetworkType-DHCP_STATIC"; break;;
        'WiFi: Static & Eth: DHCP' ) varIpType="$varNetworkType-STATIC_DHCP"; break;;
        'WiFi: Static & Eth: Static' ) varIpType="$varNetworkType-STATIC_STATIC"; break;;
        'Exit' ) exit 1; break;;
      esac
    done
}
