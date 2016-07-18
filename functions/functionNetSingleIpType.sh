#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for DHCP or Static IP configuraton and write -
###       it back as a variable.
function functionNetSingleIpType {
  echo "####################################################################################"
  echo "Select what type of IP address needs to be configured: 'DHCP' or 'STATIC' IP;"
  echo "####################################################################################"
    select yn in "DHCP" "STATIC"; do
      case $yn in
        'DHCP' ) varIpType="$varNetworkType-DHCP"; break;;
        'STATIC' ) varIpType="$varNetworkType-STATIC"; break;;
      esac
    done
}
