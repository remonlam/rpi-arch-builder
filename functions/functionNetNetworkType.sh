#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for a network type and write it back as -
###       a variable.
function functionNetNetworkType {
  echo "####################################################################################"
  echo "Select the network type you want to configure 'Wi-Fi', 'Ethernet' or 'Both';"
  echo "####################################################################################"
    select yn in "Wi-Fi" "Ethernet" "Wi-Fi & Ethernet"; do
      case $yn in
        'Wi-Fi' ) varNetworkType="WIFI"; break;;
        'Ethernet' ) varNetworkType="ETH"; break;;
        'Wi-Fi & Ethernet' ) varNetworkType="DUAL"; break;;
      esac
    done
}
