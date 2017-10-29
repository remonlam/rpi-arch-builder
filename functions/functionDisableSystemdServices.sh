#!/bin/bash

#########################################################################################
### NOTE: This function will remove the SystemctlNetwork and SystemctlDNS services -
###       to prevent DHCP from kicking in during boot and make DNS to point to the -
###       configured addresses.
function functionDisableSystemdServices {
# Remove systemd-networkd & systemd-resolved
rm -rf /temp/root/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
rm -rf /temp/root/etc/systemd/system/multi-user.target.wants/systemd-resolved.service
rm -rf /temp/root/etc/systemd/system/socket.target.wants/systemd-resolved.socket

# Remove old resolv.conf
rm -rf /etc/resolv.conf

# Create new resolv.conf file
if [ "$varNetworkType" = "WIFI" ]; then
  echo "Setup Fixed IP settings for: ##"
  echo "#########################################################################"
      echo -e "search $dnsSearch\nnameserver $wifiDns1\nnameserver $wifiDns2" > /etc/resolv.conf
  elif [ "$varNetworkType" = "ETH" ]; then
      echo "Setup Fixed IP settings for: ##"
      echo "#########################################################################"
              echo -e "search $dnsSearch\nnameserver $ethernetDns1\nnameserver $ethernetDns2" > /etc/resolv.conf
  elif [ "$varNetworkType" = "DUAL" ]; then
      echo "Setup Fixed IP settings for: ##"
      echo "#########################################################################"
        echo -e "search $dnsSearch\nnameserver $ethernetDns1\nnameserver $ethernetDns2" > /etc/resolv.conf
          fi
#fi
}
