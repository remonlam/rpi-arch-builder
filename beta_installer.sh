#!/bin/bash

#########################################################################################
### RUNTIME CHECK                                                                     ###
#########################################################################################

# Check if script is running as root, if not then exit




#########################################################################################
###   FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS     ###
#########################################################################################

###################################
## System functions
###################################

#########################################################################################
### NOTE: This function will remove the SystemctlNetwork and SystemctlDNS services -
###       to prevent DHCP from kicking in during boot and make DNS to point to the -
###       configured addresses.
function disableSystemctlServices {
# Remove SystemctlNetwork
rm /temp/root/etc/systemctl/../../../

# Remove Systemctl-DNS
rm /temp/root/etc/systemctl/../../../
}


#########################################################################################



#########################################################################################
test


#########################################################################################




###################################
## Network functions
###################################

#########################################################################################
### NOTE: This function will ask the user for a hostname and write it back as a variable.
function hostName {
  echo "####################################################################################"
  echo "Enter a hostname only, do no include a domain name!;"
  echo "####################################################################################"
    read -p 'Enter a hostname: ' varHostName

  # Change hostname
    sed -i 's/alarmpi/'$varHostName'/' /temp/root/etc/hostname
}
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for a network type and write it back as -
###       a variable.
function networkType {
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
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for the accespoint credentials and write it -
###       back as a variable.
###       It will write back the values to the corresponding netctl configuration files.
function accpCredentials {
  echo "####################################################################################"
  echo "Enter the credentials for your accesspoint"
  echo "####################################################################################"
    read -p 'Enter wifi name (Accesspoint): ' wifiAp
    read -p 'Enter wifi password: ' wifiKey

  echo "Prepping WiFi netctl config files"
    sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAp'/" /temp/root/etc/netctl/wlan0
    sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
}
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for DHCP or Static IP configuraton and write -
###       it back as a variable.
function singleIpType {
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
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for DHCP or Static IP configuraton and write -
###       it back as a variable.
###
### NOTE: This function is used when a user want's to use both WiFi and Ethernet.
function dualIpType {
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
#########################################################################################



#########################################################################################
### NOTE: This function will write netctl configuration files when using WiFi.
###
### NOTE: This function is used only for Wifi
function ipWifiDynamic {
  echo "Setup Dynamic IP settings for: $varIpType"
  echo "#########################################################################"

# Downloading netctl template files and wpa packages
  {
  # Download "libnl" and "wpa_supplicant" package tar.gz file from GitHub
    wget -P /temp/ https://github.com/remonlam/rpi-zero-arch/raw/master/packages/libnl_wpa_package.tar.gz
  # Extract tar.gz file to root/
    tar -xf /temp/libnl_wpa_package.tar.gz -C /temp/root/
  # Copy netctl wlan0 config file
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/wlan0
    cp -rf /temp/wlan0 /temp/root/etc/netctl/
  # Copy wlan0.service file to systemd and create symlink to make it work at first boot
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40wlan0.service
    cp -rf /temp/netctl@wlan0.service /temp/root/etc/systemd/system/
    ln -s '/temp/root/etc/systemd/system/netctl@wlan0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@wlan0.service'
  } &> /dev/null
}
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for Static IP configuration and write -
###       it back as a variable.
###
### NOTE: This function is used only for WiFi
function ipWifiStatic {
  echo "Setup Fixed IP settings for WiFi: $varIpType"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' wifiIp
    read -p 'Enter IP Subnet, example: 24: ' wifiMask
    read -p 'Enter Gateway: ' wifiGateway
    read -p 'Enter DNS 1: ' wifiDns1
    read -p 'Enter DNS 2: ' wifiDns2
    read -P 'Enter DNS Search domain: ' dnsSearch

# Downloading netctl template files and wpa packages
  {
  # Download "libnl" and "wpa_supplicant" package tar.gz file from GitHub
    wget -P /temp/ https://github.com/remonlam/rpi-zero-arch/raw/master/packages/libnl_wpa_package.tar.gz
  # Extract tar.gz file to root/
    tar -xf /temp/libnl_wpa_package.tar.gz -C /temp/root/
  # Copy netctl wlan0 config file
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/wlan0
    cp -rf /temp/wlan0 /temp/root/etc/netctl/
  # Copy wlan0.service file to systemd and create symlink to make it work at first boot
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40wlan0.service
    cp -rf /temp/netctl@wlan0.service /temp/root/etc/systemd/system/
    ln -s '/temp/root/etc/systemd/system/netctl@wlan0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@wlan0.service'
  } &> /dev/null

# Prepping Ethernet configuration files
  echo "Prepping WiFi netctl config files"
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$wifiIp/$wifiMask')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$wifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$wifiDns1' '$wifiDns2')" /temp/root/etc/netctl/wlan0
}
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for Static IP configuration and write -
###       it back as a variable.
###
### NOTE: This function is used only for Ethernet
function ipEthernetStatic {
  echo "Setup Fixed IP settings for Ethernet: $varIpType"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' ethernetIp
    read -p 'Enter IP Subnet, example: 24: ' ethernetMask
    read -p 'Enter Gateway: ' ethernetGateway
    read -p 'Enter DNS 1: ' ethernetDns1
    read -p 'Enter DNS 2: ' ethernetDns2
    read -P 'Enter DNS Search domain: ' dnsSearch

# Downloading netctl template files
  {
  # Copy netctl eth0 config file
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/eth0
    cp -rf /temp/eth0 /temp/root/etc/netctl/
  # Copy wlan0.service file to systemd and create symlink to make it work at first boot
    wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40eth0.service
    cp -rf /temp/netctl@eth0.service /temp/root/etc/systemd/system/
    ln -s '/temp/root/etc/systemd/system/netctl@eth0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@eth0.service'
  } &> /dev/null

# Prepping Ethernet configuration files
  echo "Prepping Ethernet netctl config files"
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/eth0
    sed -i "/IP=static/ a Address=('$ethernetIp/$ethernetMask')" /temp/root/etc/netctl/eth0
    sed -i "/Address=/ a Gateway=('$ethernetGateway')" /temp/root/etc/netctl/eth0
    sed -i "/Gateway=/ a DNS=('$ethernetDns1' '$ethernetDns2')" /temp/root/etc/netctl/eth0

 # Remove "systemd-networkd.service"
    rm -rf /temp/root/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
    rm -rf /temp/root/etc/systemd/system/socket.target.wants/systemd-networkd.service
}
#########################################################################################



#########################################################################################
### NOTE: This function will ask the user for a network and IP type and write it back -
###       as a variable.
###       After selecting WIFI/ETH/DUAL it selects IP configuration for DHCP/STATIC.
###
### NOTE: This function has several dependencies of other functions!
###
function networkProfileSelection {
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
#########################################################################################




#########################################################################################



###################################
## Script functions
###################################









#########################################################################################
### RUNTIME                                                                           ###
#########################################################################################

# Run functions
masterFunction
functionSelectArmVersion
functionRootCheck
functionFormatDisk
selectArmVersion
networkProfileSelection
#functionDisableSystemdServices
systemPreConfiguration
functionCleanup
printConfigSummary
