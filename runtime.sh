#!/bin/sh

# Set vars
read -p 'Select network type: wifi/cable/both: ' networkType


# Check what type of networking is used
echo "Check what network type is used: '$networkType'"
if [ $networkType = "wifi" ]; then
  echo "Using Wi-Fi networking"
    read -p 'Enter wifi interface: example; wlan0 ' wifiInterface
    read -p 'Enter wifi name (Accesspoint): ' wifiAP
    read -p 'Enter wifi password: ' wifiKey
    read -p 'Using DHCP or Fixed IP: DHCP/FIXED ' wifiIpType
elif [ $networkType = "cable" ]; then
  echo "Using Ethernet/cable networking"
    read -p 'Enter ethernet interface: example; eth0 ' ethernetInterface
    read -p 'Using DHCP or Fixed IP: DHCP/FIXED ' ethernetIpType
elif [ $networkType = "both" ]; then
 echo "Using both Wi-Fi and Ethernet networking"
    read -p 'Enter wifi interface: example; wlan0 ' wifiInterface
    read -p 'Enter wifi name (Accesspoint): ' wifiAP
    read -p 'Enter wifi password: ' wifiKey
    read -p 'Enter ethernet interface: example; eth0 ' ethernetInterface
else
   echo "'$networkType' = Invalid variable: ....Go home your drunk...."
   exit 1
fi
echo "###########################################"
echo "Network selection has been set correctly..."
echo "###########################################"


# Check if DHCP or FIXED IP needs to be configured
echo "Check if DHCP or FIXED IP needs to be configured"
if [ "$wifiIpType" = "FIXED" ]; then
  echo "Setup Fixed IP settings for: '$networkType'"
    read -p 'Enter IP Address: ' networkWifiIP
    read -p 'Enter IP Subnet: ' networkWifiSubnet
    read -p 'Enter Gateway: ' networkWifiGateway
    read -p 'Enter DNS 1: ' networkWifiDns1
    read -p 'Enter DNS 2: ' networkWifiDns2
elif [ "$ethernetIpType" = "FIXED" ]; then
  echo "Setup Fixed IP settings for: '$networkType'"
    read -p 'Enter IP Address: ' networkEthernetIP
    read -p 'Enter IP Subnet: ' networkEthernetSubnet
    read -p 'Enter Gateway: ' networkEthernetGateway
    read -p 'Enter DNS 1: ' networkEthernetDns1
    read -p 'Enter DNS 2: ' networkEthernetDns2
elif [ "$networkType" = "both" ]; then
  echo "Setup Fixed IP settings for: Wi-Fi"
  echo "###########################################"
    read -p 'Enter IP Address: ' networkWifiIP
    read -p 'Enter IP Subnet: ' networkWifiSubnet
    read -p 'Enter Gateway: ' networkWifiGateway
    read -p 'Enter DNS 1: ' networkWifiDns1
    read -p 'Enter DNS 2: ' networkWifiDns2
  echo "Setup Fixed IP settings for: Ethernet"
  echo "###########################################"
    read -p 'Enter IP Address: ' networkEthernetIP
    read -p 'Enter IP Subnet: ' networkEthernetSubnet
    read -p 'Enter Gateway: ' networkEthernetGateway
    read -p 'Enter DNS 1: ' networkEthernetDns1
    read -p 'Enter DNS 2: ' networkEthernetDns2
else
  echo "'$networkType' = Invalid variable: ....Go home your drunk...."
    exit 1
fi
echo "###########################################"
echo "IP type selection has been set correctly..."
echo "###########################################"
