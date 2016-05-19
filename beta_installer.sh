#!/bin/sh

### RUNTIME CHECK
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



### SCRIPT VARIABLES
# Set fixed variables
part1=1
part2=2

# Ask user for system specific variables
echo "#########################################################################"
echo "NOTE: Select the correct version of ARM is nessesarly for downloading"
echo "      the corresponding version of the Arch ARM Linux image"
echo ""
echo "Select 'ARM v6' when using models like:  PI 1 MODEL A+"
echo "                                       PI 1 MODEL B+"
echo "                                       PI ZERO"
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

# Collect other nessesarly variables
echo "#########################################################################"
read -p 'Enter device name (SD-Card): like sdb: ' sdCard

echo "Are you sure that device '$sdCard' can be used all data will be removed"
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
echo "Device '$sdCard' has been removed successfully"
echo "####################################################################################"
echo ""
echo ""


read -p 'Enter a hostname: ' hostName
echo "#########################################################################"
echo ""
echo ""
echo "Select the network type you want to configure 'Wi-Fi', 'Ethernet' or 'Both';"
echo "####################################################################################"
select yn in "Wi-Fi" "Ethernet" "Wi-Fi & Ethernet"; do
    case $yn in
        'Wi-Fi' ) networkType="wifi"; break;;
        'Ethernet' ) networkType="ethernet"; break;;
        'Wi-Fi & Ethernet' ) networkType="both"; break;;
 esac
done

# Check what type of networking is used
echo "#########################################################################"
echo "Check what network type is used: '$networkType'"
echo "#########################################################################"
if [ $networkType = "wifi" ]; then
  echo "Using Wi-Fi networking"
    read -p 'Enter wifi name (Accesspoint): ' wifiAP
    read -p 'Enter wifi password: ' wifiKey
    echo "Select what type of IP address needs to be configured: 'DHCP' or 'STATIC' IP;"
    echo "####################################################################################"
      select yn in "DHCP" "STATIC"; do
        case $yn in
            'DHCP' ) wifiIpType="DHCP"; break;;
            'STATIC' ) wifiIpType="STATIC"; break;;
     esac
    done
        elif [ $networkType = "ethernet" ]; then
          echo "Using Ethernet networking"
            echo "Select what type of IP address needs to be configured: 'DHCP' or 'STATIC' IP;"
            echo "####################################################################################"
            select yn in "DHCP" "STATIC"; do
                case $yn in
                    'DHCP' ) ethernetIpType="DHCP"; break;;
                    'STATIC' ) ethernetIpType="STATIC"; break;;
             esac
            done
        elif [ $networkType = "both" ]; then
         echo "Using both Wi-Fi and Ethernet networking"
         echo "Wi-Fi configuration:"
            read -p 'Enter wifi name (Accesspoint): ' wifiAP
            read -p 'Enter wifi password: ' wifiKey
            echo "Select what type of IP address needs to be configured; 'DHCP' or 'STATIC' IP;"
            echo "####################################################################################"
            select yn in "DHCP" "STATIC"; do
              case $yn in
                'DHCP' ) wifiIpType="DHCP"; break;; # <--- need to change wifiIpType to something else
                'STATIC' ) wifiIpType="STATIC"; break;; # <--- need to change wifiIpType to something else
              esac
            done
            echo "Ethernet (wired) configuration:"
            echo "Select what type of IP address needs to be configured: 'DHCP' or 'STATIC' IP;"
            echo "####################################################################################"
            select yn in "DHCP" "STATIC"; do
                 case $yn in
                   'DHCP' ) ethernetIpType="DHCP"; break;;
                   'STATIC' ) ethernetIpType="STATIC"; break;;
                 esac
            done

else
   echo "'$networkType' = Invalid variable: ....Go home your drunk...."
   exit 1
fi
echo "#########################################################################"
echo "Network selection has been set correctly..."
echo "#########################################################################"
echo ""
echo ""

## Check if DHCP or FIXED IP needs to be configured
echo "#########################################################################"
echo "Check if DHCP or STATIC IP needs to be configured"
echo "NOTE: This let's you choose between Wi-Fi, Ethernet or both of them"
echo "#########################################################################"
if [ "$networkType" = "both" ]; then
  echo "DEBUG: show network type: '$networkType'"
  echo "Setup Fixed IP settings for: Wi-Fi"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' networkWifiIP
    read -p 'Enter IP Subnet, example: 24: ' networkWifiSubnet
    read -p 'Enter Gateway: ' networkWifiGateway
    read -p 'Enter DNS 1: ' networkWifiDns1
    read -p 'Enter DNS 2: ' networkWifiDns2
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
  echo "Setup Fixed IP settings for: Ethernet"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' networkEthernetIP
    read -p 'Enter IP Subnet, example: 24: ' networkEthernetSubnet
    read -p 'Enter Gateway: ' networkEthernetGateway
    read -p 'Enter DNS 1: ' networkEthernetDns1
    read -p 'Enter DNS 2: ' networkEthernetDns2
  elif [ "$wifiIpType" = "STATIC" ]; then
    echo "Setup Fixed IP settings for: WiFi-Static"
      read -p 'Enter IP Address: ' networkWifiIP
      read -p 'Enter IP Subnet, example: 24: ' networkWifiSubnet
      read -p 'Enter Gateway: ' networkWifiGateway
      read -p 'Enter DNS 1: ' networkWifiDns1
      read -p 'Enter DNS 2: ' networkWifiDns2
  elif [ "$ethernetIpType" = "STATIC" ]; then
    echo "Setup Fixed IP settings for: Ethernet-Static"
      read -p 'Enter IP Address: ' networkEthernetIP
      read -p 'Enter IP Subnet, example: 24: ' networkEthernetSubnet
      read -p 'Enter Gateway: ' networkEthernetGateway
      read -p 'Enter DNS 1: ' networkEthernetDns1
      read -p 'Enter DNS 2: ' networkEthernetDns2
  else
    echo "You're selected DHCP so no IP settings needs to be configured"
fi
echo "#########################################################################"
echo "IP type selection has been set correctly..."
echo "#########################################################################"
echo ""
echo ""



### DISK CONFIGURATION
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

#Create and mount the FAT filesystem:
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



### DOWNLOAD & EXTRACT IMAGE
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



### System configuration
echo "#########################################################################"
echo "System pre-configuration"
echo "#########################################################################"
# Change rotation of Pi Screen' >> /temp/boot/config.txt
echo lcd_rotate=2 >> /temp/boot/config.txt
# Change GPU memory from 64MB to 16MB
sed -i 's/gpu_mem=64/gpu_mem=16/' /temp/boot/config.txt
# Enable root logins for sshd
sed -i "s/"#"PermitRootLogin prohibit-password/PermitRootLogin yes/" /temp/root/etc/ssh/sshd_config
# Change hostname
sed -i 's/alarmpi/'$hostName'/' /temp/root/etc/hostname
# Download post configuration script and make file executable
{
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/configure-system.sh
chmod 755 /temp/configure-system.sh
} &> /dev/null
# Copy "configure-system.sh" script to "root"
mv /temp/configure-system.sh /temp/root
echo "#########################################################################"
echo ""
echo ""



### NETWORKING
echo "#########################################################################"
echo "Network configuration"
echo "#########################################################################"
# Check network type and create netctl service
if [ $networkType = "wifi" ]; then
  echo "Using Wi-Fi networking"
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
elif [ $networkType = "ethernet" ]; then
  echo "Using Ethernet networking"
    {
      # Copy netctl eth0 config file
       wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/eth0
       cp -rf /temp/eth0 /temp/root/etc/netctl/
      # Copy wlan0.service file to systemd and create symlink to make it work at first boot
       wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40eth0.service
       cp -rf /temp/netctl@eth0.service /temp/root/etc/systemd/system/
       ln -s '/temp/root/etc/systemd/system/netctl@eth0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@eth0.service'
    } &> /dev/null
elif [ $networkType = "both" ]; then
  echo "Using Wi-Fi networking"
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
  echo "Using Ethernet networking"
    {
      # Copy netctl eth0 config file
       wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/eth0
       cp -rf /temp/eth0 /temp/root/etc/netctl/
      # Copy eth0.service file to systemd and create symlink to make it work at first boot
       wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/networking/netctl%40wlan0.service
       cp -rf /temp/netctl@eth0.service /temp/root/etc/systemd/system/
       ln -s '/temp/root/etc/systemd/system/netctl@eth0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@eth0.service'
    } &> /dev/null
else
  echo "'Something went wrong but I have no idea why.... have fun debugging ;-)"
    exit 1
fi
echo "#########################################################################"
echo ""
echo ""

# Setup Ethernet & WiFi configuration files
if [ "$wifiIpType" = "STATIC" ]; then
  echo "Prepping Wi-Fi config files for STATIC IP configuration"
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
    sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAP'/" /temp/root/etc/netctl/wlan0
    sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
  echo "Prepping done..."
    elif [ "$wifiIpType" = "DHCP" ]; then
        echo "Prepping WiFi config files for DHCP IP configuration"
          sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAP'/" /temp/root/etc/netctl/wlan0
          sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
        echo "Prepping done..."
    elif [ "$ethernetIpType" = "DHCP" ]; then
        echo "Prepping Ethernet config files for DHCP IP configuration"
        echo "Prepping done..."
    elif [ "$ethernetIpType" = "STATIC" ]; then
        echo "Prepping Ethernet config files for STATIC IP configuration"
          sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/eth0
          sed -i "/IP=static/ a Address=('$networkEthernetIP/$networkEthernetSubnet')" /temp/root/etc/netctl/eth0
          sed -i "/Address=/ a Gateway=('$networkEthernetGateway')" /temp/root/etc/netctl/eth0
          sed -i "/Gateway=/ a DNS=('$networkEthernetDns1' '$networkEthernetDns2')" /temp/root/etc/netctl/eth0
        echo "Prepping done..."
    elif [ "$networkType" = "both" ]; then
        echo "Prepping WiFi & Ethernet config files for STATIC IP configuration"
        # Wi-Fi
          sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
          sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
          sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
          sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
          sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAP'/" /temp/root/etc/netctl/wlan0
          sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
        # Ethernet
          sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/eth0
          sed -i "/IP=static/ a Address=('$networkEthernetIP/$networkEthernetSubnet')" /temp/root/etc/netctl/eth0
          sed -i "/Address=/ a Gateway=('$networkEthernetGateway')" /temp/root/etc/netctl/eth0
          sed -i "/Gateway=/ a DNS=('$networkEthernetDns1' '$networkEthernetDns2')" /temp/root/etc/netctl/eth0
        echo "Prepping done..."
else
    echo "'Something went wrong but I have no idea why.... have fun debugging ;-)"
    exit 1
fi
echo "#########################################################################"
echo ""
echo ""



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
exit 0
echo "#########################################################################"
