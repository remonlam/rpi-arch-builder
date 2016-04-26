#!/bin/sh

#### TODO;
#### TESTING:
#### IMAGE SELECTION: Needs to be changed if the RPI3 use a different image;
####

### RUNTIME CHECK
# Check if script is running as root, if not then exit
echo "THIS SCRIPT NEEDS TO BE RUN AS ROOT, CHECKING..."
if [ `id -u` = 0 ] ; then
        echo "Running as ROOT, continue with script..."
        ### PRE-REQUIREMENTS
        # Check or install wget, tar and badtar
        yum install -y wget bsdtar tar

        # Wipe microSD card @ $sdCard
        #echo "Wipe microSD card ('$sdCard')"
        #dd if=/dev/zero of=/dev/$sdCard bs=1M count=1
  else
echo "Not running as ROOT exit script..."
exit 1
fi


### SCRIPT VARIABLES
# Set fixed variables
part1=1
part2=2

# Ask user for system specific variables
echo "########################################################################"
echo "NOTE: Select the correct version of ARM is nessesarly for downloading"
echo "      the corresponding version of the Arch ARM Linux image"
echo ""
echo "Select 'arm6' when using models like:  PI 1 MODEL A+"
echo "                                       PI 1 MODEL B+"
echo "                                       PI ZERO"
echo ""
echo "Select 'arm7' when using models like:  PI 2 MODEL B"
echo ""
echo "Select 'arm8' when using models like:  PI 3 MODEL B"
echo "########################################################################"
echo ""



# Ask user for type or ARM processor
read -p 'What version of ARM?: arm6 / arm7 / arm8: ' armVersion
echo "########################################################################"
if [ $armVersion = "arm6" ]; then
  echo "Using ARM version: '$armVersion'"
elif [ $armVersion = "arm7" ]; then
  echo "Using ARM version: '$armVersion'"
elif [ $armVersion = "arm8" ]; then
  echo "Using ARM version: '$armVersion'"
else
   echo "'$armVersion' is an invalid ARM version!!!!, should be something like 'arn#'"
   exit 1
fi

# Collect other nessesarly variables
read -p 'Enter device name (SD-Card): like sdb: ' sdCard
read -p 'Enter a hostname: ' hostName
read -p 'Select network type: wifi/ethernet/both: ' networkType

# Check what type of networking is used
echo "##############################################################"
echo "Check what network type is used: '$networkType'"
echo "##############################################################"
if [ $networkType = "wifi" ]; then
  echo "Using Wi-Fi networking"
    read -p 'Enter wifi interface: example; wlan0 ' wifiInterface
    read -p 'Enter wifi name (Accesspoint): ' wifiAP
    read -p 'Enter wifi password: ' wifiKey
    read -p 'Using DHCP or Fixed IP: DHCP/FIXED ' wifiIpType
elif [ $networkType = "ethernet" ]; then
  echo "Using Ethernet networking"
    read -p 'Enter ethernet interface: example; eth0 ' ethernetInterface
    read -p 'Using DHCP or Fixed IP: DHCP/FIXED ' ethernetIpType
elif [ $networkType = "both" ]; then
 echo "Using both Wi-Fi and Ethernet networking"
    read -p 'Enter wifi interface: example; wlan0 ' wifiInterface
    read -p 'Enter wifi name (Accesspoint): ' wifiAP
    read -p 'Enter wifi password: ' wifiKey
    read -p 'Using DHCP or Fixed IP: DHCP/STATIC ' wifiIpType
    read -p 'Enter ethernet interface: example; eth0 ' ethernetInterface
else
   echo "'$networkType' = Invalid variable: ....Go home your drunk...."
   exit 1
fi
echo "###########################################"
echo "Network selection has been set correctly..."
echo "###########################################"
echo ""
echo ""


## Check if DHCP or FIXED IP needs to be configured
echo "##############################################################"
echo "Check if DHCP or STATIC IP needs to be configured"
echo "**************************************************************"
echo "This let's you choose between Wi-Fi, Ethernet or both of them"
echo "##############################################################"
if [ "$wifiIpType" = "STATIC" ]; then
  echo "Setup Fixed IP settings for: '$networkType'"
    read -p 'Enter IP Address: ' networkWifiIP
    read -p 'Enter IP Subnet, example: /24: ' networkWifiSubnet
    read -p 'Enter Gateway: ' networkWifiGateway
    read -p 'Enter DNS 1: ' networkWifiDns1
    read -p 'Enter DNS 2: ' networkWifiDns2
  elif [ "$ethernetIpType" = "STATIC" ]; then
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
    ###
    # Replace DHCP to STATIC
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
    ###
  echo "Setup Fixed IP settings for: Ethernet"
  echo "###########################################"
    read -p 'Enter IP Address: ' networkEthernetIP
    read -p 'Enter IP Subnet: ' networkEthernetSubnet
    read -p 'Enter Gateway: ' networkEthernetGateway
    read -p 'Enter DNS 1: ' networkEthernetDns1
    read -p 'Enter DNS 2: ' networkEthernetDns2
else
  echo "You're selected DHCP so no IP settings needs to be configured"
fi
echo "###########################################"
echo "IP type selection has been set correctly..."
echo "###########################################"
echo ""
echo ""



##fdisk /dev/$sdCard
# Create parition layout
echo "Create new parition layout on '$sdCard'"
# NOTE: This will create a partition layout as beeing described in the README...
(echo o; echo n; echo p; echo 1; echo ; echo +100M; echo t; echo c; echo n; echo p; echo 2; echo ; echo ; echo w) | fdisk /dev/$sdCard
# Sync disk
sync

#Create and mount the FAT filesystem:
echo "Create and mount the FAT filesystem on '$sdCard$part1'"
mkfs.vfat /dev/$sdCard$part1
mkdir -p /temp/boot
mount /dev/$sdCard$part1 /temp/boot

#Create and mount the ext4 filesystem:
echo "Create and mount the ext4 filesystem on '$sdCard$part2'"
mkfs.ext4 /dev/$sdCard$part2
mkdir -p /temp/root
mount /dev/$sdCard$part2 /temp/root

# Download Arch Linux ARM image, check what version ARM v6 or v7
echo "Download Arch Linux ARM v'$armVersion' and expand to root"
  if [ $armVersion=6 ]; then
    echo "Downloading Arch Linux ARM v'$armVersion'"
     wget -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
    echo "Download complete, expanding tar.gz to root"
     bsdtar -xpf /temp/ArchLinuxARM-rpi-latest.tar.gz -C /temp/root
     sync
  else
    echo "Downloading Arch Linux ARM v'$armVersion'"
     wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
    echo "Download complete, expanding tar.gz to root"
     bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
     sync
  fi
echo "Download and extract complete"

#Move boot files to the first partition:
mv /temp/root/boot/* /temp/boot
echo '# Change rotation of Pi Screen' >> /temp/boot/config.txt
echo lcd_rotate=2 >> /temp/boot/config.txt

# Change GPU memory from 64MB to 16MB
sed -i 's/gpu_mem=64/gpu_mem=16/' /temp/boot/config.txt


### NETWORKING

if [ "$wifiIpType" = "STATIC" ]; then
  echo "Prepping Wi-Fi config files for STATIC IP configuration"
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
    sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAP'/" /temp/root/etc/netctl/wlan0
    sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
  echo "Prepping done..."
elif [ "$ethernetIpType" = "STATIC" ]; then
  echo "Prepping Wi-Fi config files for STATIC IP configuration"
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/eth0
    sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/eth0
    sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/eth0
    sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/eth0
  echo "Prepping done..."
elif [ $armVersion = "arm8" ]; then
  echo "Using ARM version: '$armVersion'"
else
   echo "'$armVersion' is an invalid ARM version!!!!, should be something like 'arn#'"
   exit 1
fi


##
# Replace DHCP to STATIC

##


# Enable root logins for sshd
sed -i "s/"#"PermitRootLogin prohibit-password/PermitRootLogin yes/" /temp/root/etc/ssh/sshd_config
# Change hostname
sed -i 's/alarmpi/'$hostName'/' /temp/root/etc/hostname

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
exit 0
