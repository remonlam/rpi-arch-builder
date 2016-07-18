#!/bin/bash

#########################################################################################
### NOTE: This function will print all configuration information at the end of this script.
###
function printShowConfig {
  echo "#########################################################################"
  echo "Display configuration information;"
  echo "#########################################################################"
    echo "IP: " $wifiIp $ethernetIp
    echo "Hostname: " $varHostName

}
#########################################################################################
