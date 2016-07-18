#!/bin/bash

## THIS SCRIPT DEPENDS ON THE FOLLOWING FUNCTIONS;
##  - hostName
##  - networkType
##  - singleIpType
##  - ipWifiStatic
##  - accpCredentials
##  - ipEthernetStatic
##  - dualIpType
##

### Import other functions before running this function
. ./functions/functionNetHostName.sh
. ./functions/functionNetNetworkType.sh
. ./functions/functionNetAccpCredentials.sh
. ./functions/functionNetSingleIpType.sh
. ./functions/functionNetDualIpType.sh
. ./functions/functionNetIpWifiStatic.sh
. ./functions/functionNetIpWifiDynamic.sh
. ./functions/functionNet
. ./functions/functionNet
. ./functions/functionNet
. ./functions/functionNet
. ./functions/functionNet
. ./functions/functionNet
. ./functions/functionNetIpEthernetStatic




#########################################################################################
### NOTE: This function will ask the user for a network and IP type and write it back -
###       as a variable.
###       After selecting WIFI/ETH/DUAL it selects IP configuration for DHCP/STATIC.
###
### NOTE: This function has several dependencies of other functions!
###
function functionsNetworkProfileSelection {
  hostName
  networkType
  if [ "$varNetworkType" = "WIFI" ]; then
    echo "Setup Fixed IP settings for: ##"
    echo "#########################################################################"
      singleIpType
      echo "show varIpType:" $varIpType
        if [ "$varIpType" = "WIFI-STATIC" ]; then
          ipWifiStatic
          accpCredentials
          elif [ "$varIpType" = "WIFI-DHCP" ]; then
            ipWifiDynamic
            accpCredentials
        fi
    elif [ "$varNetworkType" = "ETH" ]; then
        echo "Setup Fixed IP settings for: ##"
        echo "#########################################################################"
          singleIpType
          echo "show varIpType:" $varIpType
            if [ "$varIpType" = "ETH-STATIC" ]; then
              ipEthernetStatic
            fi
    elif [ "$varNetworkType" = "DUAL" ]; then
        echo "Setup Fixed IP settings for: ##"
        echo "#########################################################################"
          dualIpType
            if [ "$varIpType" = "DUAL-STATIC_DHCP" ]; then
              echo "DEBUG: setup config for 'DUAL-STATIC_DHCP'"
                ipWifiStatic
                accpCredentials
              elif [ "$varIpType" = "DUAL-DHCP_STATIC" ]; then
                echo "DEBUG: setup config for 'DUAL-DHCP_STATIC'"
                  ipWifiDynamic
                  accpCredentials
                  ipEthernetStatic
              elif [ "$varIpType" = "DUAL-STATIC_STATIC" ]; then
                echo "DEBUG: setup config for 'DUAL-STATIC_STATIC'"
                  ipWifiStatic
                  accpCredentials
                  ipEthernetStatic
              elif [ "$varIpType" = "DUAL-DHCP_DHCP" ]; then
                echo "DEBUG: setup config for 'DUAL-DHCP_DHCP'"
                  ipWifiDynamic
                  accpCredentials
            fi
  fi
}
