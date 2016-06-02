#!/bin/bash

#########################################################################################
### RUNTIME CHECK                                                                     ###
#########################################################################################

# Check if script is running as root, if not then exit
echo "#########################################################################"
echo "THIS SCRIPT NEEDS TO BE RUN AS ROOT, CHECKING..."
if [ `id -u` = 0 ] ; then
        echo "Running as ROOT, continue with script..."
        echo "#########################################################################"
        ### PRE-REQUIREMENTS
        # Check or install wget, tar and badtar
        {
          echo "Install 'wget, bsdtar & tar'"
        yum install -y wget bsdtar tar
        } &> /dev/null
        echo "#########################################################################"
        echo ""
        echo ""
  else
        echo "#########################################################################"
        echo "Not running as ROOT, exit script..."
        echo "#########################################################################"
    exit 1
fi



#########################################################################################
###   FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS  FUNCTIONS     ###
#########################################################################################

###################################
## System functions
###################################

#########################################################################################
### NOTE: This function will format the disk, create new partitions / filesystem -
###       Mount it to /temp/boot & /temp/root.
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

# Set fixed variables
  part1=1
  part2=2

# Unmount partitions
  {
    sudo umount /dev/$sdCard$part1
    sudo umount /dev/$sdCard$part2
  } &> /dev/null

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
  echo "#########################################################################"
  echo "Create parition layout on '$sdCard'"
  echo "#########################################################################"
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

# Create new filesystem & mount it to /temp/*
  echo "#########################################################################"
  echo "Create temporary mount point for 'root' and 'boot'"
  echo "#########################################################################"
  echo "Create and mount the FAT filesystem on '$sdCard$part1'"
  {
    sleep 5
    mkfs.vfat /dev/$sdCard$part1
    mkdir -p /temp/boot
    mount /dev/$sdCard$part1 /temp/boot
  } &> /dev/null
  echo ""

  echo "Create and mount the ext4 filesystem on '$sdCard$part2'"
  {
    mkfs -t ext4 /dev/$sdCard$part2
    mkdir -p /temp/root
    mount /dev/$sdCard$part2 /temp/root
  } &> /dev/null
  echo "#########################################################################"
  echo ""
  echo ""
}
#########################################################################################



#########################################################################################
### NOTE: This function will check if the Arch Linux image is present on the disk
function checkForImage {
  FILE="ArchLinuxARM-rpi-latest.tar.gz"
  if [ -f "$FILE" ];
    then
       echo "File $FILE exist."
    else
       echo "File $FILE does not exist" >&2
  fi
}
#########################################################################################
test


#########################################################################################
### NOTE: This function will select the correct Arch Linux ARM version, download and -
###       extract the image to the SD card.
function selectArmVersion {
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
      echo "Download complete, expanding image to root"
       {
       bsdtar -xpf /temp/ArchLinuxARM-rpi-latest.tar.gz -C /temp/root
       sync
       } &> /dev/null
       elif [ $armVersion = 7 ]; then
         echo "Downloading Arch Linux ARM v7"
          wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
         echo "Download complete, expanding image to root"
          {
          bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
          sync
          } &> /dev/null
       elif [ $armVersion = 8 ]; then
         echo "Downloading Arch Linux ARM v8, but the image is still v7 :-("
          wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
         echo "Download complete, expanding image to root"
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
#########################################################################################


function systemPreConfiguration {
# System configuration
  echo "#########################################################################"
  echo "System pre-configuration"
  echo "#########################################################################"
# Change rotation of Pi Screen' >> /temp/boot/config.txt
  echo lcd_rotate=2 >> /temp/boot/config.txt
# Change GPU memory from 64MB to 16MB
  sed -i 's/gpu_mem=64/gpu_mem=16/' /temp/boot/config.txt
# Enable root logins for sshd
  sed -i "s/"#"PermitRootLogin prohibit-password/PermitRootLogin yes/" /temp/root/etc/ssh/sshd_config
# Download post configuration script and make file executable
  {
  wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/sources/configure-system.sh
  chmod 755 /temp/configure-system.sh
  } &> /dev/null
# Copy "configure-system.sh" script to "root"
  mv /temp/configure-system.sh /temp/root
  echo "#########################################################################"
  echo ""
  echo ""
}


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



###################################
## Script functions
###################################

#########################################################################################
### NOTE: This function unmount disk and cleanup /temp/.
###
function cleanupFunction {
### UNMOUNT DISK & CLEANUP
echo "#########################################################################"
echo "Unmount disks and cleanup /temp directory"
echo "#########################################################################"
# Do a final sync, and wait 5 seconds before unmouting
sync
echo "Wait 5 seconds before unmouting 'boot' and 'root' mount points"
sleep 5

#Unmount the boot and root partitions:
umount /temp/boot /temp/root
echo "Unmount completed, it's safe to remove the microSD card!"

# Removing data sources
echo "Remove datasources, waiting until mount points are removed"
sleep 5
rm -rf /temp/
echo "All files in /temp/ are removed!"
echo "#########################################################################"
}
#########################################################################################



#########################################################################################
### NOTE: This function will print all configuration information at the end of this script.
###
function printConfigSummary {
  echo "#########################################################################"
  echo "Display configuration information;"
  echo "#########################################################################"
    echo "IP: " $wifiIp $ethernetIp
    echo "Hostname: " $varHostName

}
#########################################################################################



#########################################################################################
### RUNTIME                                                                           ###
#########################################################################################

formatSdCard
selectArmVersion
networkProfileSelection
systemPreConfiguration
cleanupFunction
printConfigSummary
