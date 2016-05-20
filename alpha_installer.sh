#!/bin/bash

#### FUNCTIONS

## Network Functions
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


function hostName {
  echo "####################################################################################"
  echo "Enter a hostname;"
  echo "####################################################################################"
  read -p 'Enter a hostname: ' varHostName
}


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


function ipSelection {
if [ $varNetworkType = "WIFI" ]; then
  echo "Using WiFi networking"
    accpCredentials
    singleIpType
      elif [ $varNetworkType = "ETH" ]; then
        echo "Using Ethernet networking"
          singleIpType
      elif [ $varNetworkType = "DUAL" ]; then
        echo "Using Dual (WiFi/Eth) networking"
          accpCredentials
          dualIpType
      else
        echo "Error; something went wrong selecting the correct 'networkType'"
fi
}


function ipConfiguration {
if [ $varNetworkType = "WIFI" ]; then
  echo "Using WiFi networking"
            elif [ $varNetworkType = "ETH" ]; then
        echo "Using Ethernet networking"
          elif [ $varNetworkType = "DUAL" ]; then
        echo "Using Dual (WiFi/Eth) networking"
          else
        echo "Error; something went wrong selecting the correct 'networkType' for the IP configuration"
fi
}


function ipWifiStatic {
echo "Setup Fixed IP settings for: $varIpType"
echo "#########################################################################"
read -p 'Enter IP Address: ' wifiIp
read -p 'Enter IP Subnet, example: 24: ' wifiMask
read -p 'Enter Gateway: ' wifiGateway
read -p 'Enter DNS 1: ' wifiDns1
read -p 'Enter DNS 2: ' wifiDns1
}


function ipEthernetStatic {
echo "Setup Fixed IP settings for: $varIpType"
echo "#########################################################################"
read -p 'Enter IP Address: ' ethernetIp
read -p 'Enter IP Subnet, example: 24: ' ethernetMask
read -p 'Enter Gateway: ' ethernetGateway
read -p 'Enter DNS 1: ' ethernetDns1
read -p 'Enter DNS 2: ' ethernetDns1
}


function networkProfileSelection {
networkType
if [ "$varNetworkType" = "WIFI" ]; then
  echo "Setup Fixed IP settings for: ##"
  echo "#########################################################################"
    accpCredentials
    singleIpType
    echo "show varIpType:" $varIpType
      if [ "$varIpType" = "WIFI-STATIC" ]; then
        ipWifiStatic
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
        accpCredentials
        dualIpType
        if [ "$varIpType" = "DUAL-STATIC_DHCP" ]; then
          echo "DEBUG: setup config for 'DUAL-STATIC_DHCP'"
          ipWifiStatic
        elif [ "$varIpType" = "DUAL-DHCP_STATIC" ]; then
          echo "DEBUG: setup config for 'DUAL-DHCP_STATIC'"
          ipEthernetStatic
        elif [ "$varIpType" = "DUAL-STATIC_STATIC" ]; then
          echo "DEBUG: setup config for 'DUAL-STATIC_STATIC'"
          ipWifiStatic
          ipEthernetStatic
        fi
fi
}


## System Functions

function selectArmVersion {
  # Set fixed variables
  part1=1
  part2=2

  # Ask user for system specific variables
  echo "#########################################################################"
  echo "NOTE: Select the correct version of ARM is nessesarly for downloading"
  echo "      the corresponding version of the Arch ARM Linux image"
  echo ""
  echo "Select 'ARM v6' when using models like:  PI 1 MODEL A+"
  echo "                                         PI 1 MODEL B+"
  echo "                                         PI ZERO"
  echo ""
  echo "Select 'ARM v7' when using models like:  PI 2 MODEL B"
  echo ""
  echo "Select 'ARM v8' when using models like:  PI 3 MODEL B"
  echo "#########################################################################"
  echo ""
  echo ""

  # Ask user for type or ARM processor
  echo "Select version of the correct ARM version, see info above for more information;"
  echo "####################################################################################"
  select yn in "ARM v6" "ARM v7" "ARM v8"; do
      case $yn in
          'ARM v6' ) armVersion="6"; break;;
          'ARM v7' ) armVersion="7"; break;;
          'ARM v8' ) armVersion="8"; break;;
   esac
  done

  # Download Arch Linux ARM image, check what version ARM v6 or v7
  echo "#########################################################################"
  echo "Download and extract Arch Linux ARM image"
  echo "#########################################################################"
  echo "Download Arch Linux ARM v'$armVersion' and expand to root"
    if [ $armVersion = 6 ]; then
      echo "Downloading Arch Linux ARM v6"
       wget -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
      echo "Download complete, expanding tar.gz to root"
       {
       bsdtar -xpf /temp/ArchLinuxARM-rpi-latest.tar.gz -C /temp/root
       sync
       } &> /dev/null
       elif [ $armVersion = 7 ]; then
         echo "Downloading Arch Linux ARM v7"
          wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
         echo "Download complete, expanding tar.gz to root"
          {
          bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
          sync
          } &> /dev/null
       elif [ $armVersion = 8 ]; then
         echo "Downloading Arch Linux ARM v8, but the image is still v7 :-("
          wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
         echo "Download complete, expanding tar.gz to root"
          {
          bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
          sync
          } &> /dev/null
      else
        echo "'Something went wrong with the arm version selecton... script will exit..."
        exit 1
    fi
  echo "Download and extract complete"

  #Move boot files to the first partition:
  mv /temp/root/boot/* /temp/boot
  echo "#########################################################################"
  echo ""
  echo ""
}


function formatSdCard {
  echo "################################################################################"
  echo "#  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING      #"
  echo "#                                                                              #"
  echo "#  This script will remove any data on the disk that will be entered bellow!!  #"
  echo "#  Make sure that you entered the correct drive!!                              #"
  echo "#                                                                              #"
  echo "################################################################################"
  read -p 'Enter device name (SD-Card): like sdX: ' sdCard

  echo "Are you sure that device '$sdCard' can be used, all data will be removed!!"
  echo "####################################################################################"
  select yn in "Yes" "No"; do
      case $yn in
          Yes ) echo; break;;
          No ) exit;;
      esac
  done
  echo "Removing all data from disk: '$sdCard'"
  echo "####################################################################################"
  # Unmount partitions
  {
  sudo umount /dev/$sdCard$part1
  sudo umount /dev/$sdCard$part2
  } &> /dev/null
  #sleep 5
  # Remove each partition
  for partition in $(parted -s /dev/$sdCard print|awk '/^ / {print $1}')
  do
     parted -s /dev/$sdCard rm ${partition}
  done
  {
  dd if=/dev/zero of=/dev/$sdCard bs=105M count=1
  } &> /dev/null
  echo "Device '$sdCard' has been successfully partitioned"
  echo "####################################################################################"
  echo ""
  echo ""

  # Partition DISK
  ##fdisk /dev/$sdCard
  echo "#########################################################################"
  echo "Create parition layout on '$sdCard'"
  echo "#########################################################################"
  # Create parition layout
  echo "Create new parition layout on '$sdCard'"
  # NOTE: This will create a partition layout as beeing described in the README...
  {
  (echo o; echo n; echo p; echo 1; echo ; echo +100M; echo t; echo c; echo n; echo p; echo 2; echo ; echo ; echo w) | fdisk /dev/$sdCard
  # Sync disk
  sync
  } &> /dev/null
  echo "#########################################################################"
  echo ""
  echo ""

  # Mout Disk
  echo "#########################################################################"
  echo "Create temporary mount point for 'root' and 'boot'"
  echo "#########################################################################"
  echo "Create and mount the FAT filesystem on '$sdCard$part1'"
  {
  sleep 5
  mkfs.vfat /dev/$sdCard$part1
  #mkfs -t vfat -F32 /dev/$sdCard$part1
  mkdir -p /temp/boot
  mount /dev/$sdCard$part1 /temp/boot
  } &> /dev/null
  echo ""

  #Create and mount the ext4 filesystem:
  echo "Create and mount the ext4 filesystem on '$sdCard$part2'"
  {
  #mkfs.ext4 /dev/$sdCard$part2
  mkfs -t ext4 /dev/$sdCard$part2
  mkdir -p /temp/root
  mount /dev/$sdCard$part2 /temp/root
  } &> /dev/null
  echo "#########################################################################"
  echo ""
  echo ""
}

## RUNTIME:
formatSdCard
selectArmVersion
hostName
networkProfileSelection
