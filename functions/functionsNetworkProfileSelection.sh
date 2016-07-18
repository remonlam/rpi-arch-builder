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
. ./functions/functionNetIpEthernetStatic.sh


#########################################################################################
### NOTE: This function will ask the user for a network and IP type and write it back -
###       as a variable.
###       After selecting WIFI/ETH/DUAL it selects IP configuration for DHCP/STATIC.
###
### NOTE: This function has several dependencies of other functions!
###
function functionsNetworkProfileSelection {
  functionNetHostName
  functionNetNetworkType
  if [ "$varNetworkType" = "WIFI" ]; then
    echo "Setup Fixed IP settings for: ##"
    echo "#########################################################################"
      functionNetSingleIpType
      echo "show varIpType:" $varIpType
        if [ "$varIpType" = "WIFI-STATIC" ]; then
          functionNetIpWifiStatic
          functionNetAccpCredentials
          elif [ "$varIpType" = "WIFI-DHCP" ]; then
            functionNetIpWifiDynamic
            functionNetAccpCredentials
        fi
    elif [ "$varNetworkType" = "ETH" ]; then
        echo "Setup Fixed IP settings for: ##"
        echo "#########################################################################"
          functionNetSingleIpType
          echo "show varIpType:" $varIpType
            if [ "$varIpType" = "ETH-STATIC" ]; then
              functionNetIpEthernetStatic
            fi
    elif [ "$varNetworkType" = "DUAL" ]; then
        echo "Setup Fixed IP settings for: ##"
        echo "#########################################################################"
          functionNetDualIpType
            if [ "$varIpType" = "DUAL-STATIC_DHCP" ]; then
              echo "DEBUG: setup config for 'DUAL-STATIC_DHCP'"
                functionNetIpWifiStatic
                functionNetAccpCredentials
              elif [ "$varIpType" = "DUAL-DHCP_STATIC" ]; then
                echo "DEBUG: setup config for 'DUAL-DHCP_STATIC'"
                  functionNetIpWifiDynamic
                  functionNetAccpCredentials
                  functionNetIpEthernetStatic
              elif [ "$varIpType" = "DUAL-STATIC_STATIC" ]; then
                echo "DEBUG: setup config for 'DUAL-STATIC_STATIC'"
                  functionNetIpWifiStatic
                  functionNetAccpCredentials
                  functionNetIpEthernetStatic
              elif [ "$varIpType" = "DUAL-DHCP_DHCP" ]; then
                echo "DEBUG: setup config for 'DUAL-DHCP_DHCP'"
                  functionNetIpWifiDynamic
                  functionNetAccpCredentials
            fi
  fi
}
