#!/bin/sh

### RUNTIME CHECK
# Check if script is running as root, if not then exit
echo "THIS SCRIPT NEEDS TO BE RUN AS ROOT, CHECKING..."
if [ `id -u` = 0 ] ; then
        echo "Running as ROOT, continue with script..."
  else
echo "Not running as ROOT exit script..."
exit 1
fi


### SCRIPT VARIABLES
## Ask user for system specific variables
echo "NOTE: PI 1 MODEL A+, PI 1 MODEL B+, PI ZERO are 6 --- PI 2 MODEL B is 7"
read -p 'What version of Pi? 6 or 7 ' armVersion
read -p 'Enter device name (SD-Card): like sdb: ' sdCard
read -p 'Enter a new hostname: ' hostName

## THIS COULD BE REMOVED WHEN USING THE NEW RUNTIME
#read -p 'Enter wifi name (Accesspoint): ' wifiAP
#read -p 'Enter wifi password: ' wifiKey

part1=1
part2=2


### PRE-REQUIREMENTS
# Check or install wget, tar and badtar
yum install -y wget bsdtar tar

# Wipe microSD card @ $sdCard
echo "Wipe microSD card ('$sdCard')"
dd if=/dev/zero of=/dev/$sdCard bs=1M count=1


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


## Download extra sources and merge it
# Download "libnl" and "wpa_supplicant" package tar.gz file from GitHub
wget -P /temp/ https://github.com/remonlam/rpi-zero-arch/raw/master/packages/libnl_wpa_package.tar.gz
# Extract tar.gz file to root/
tar -xf /temp/libnl_wpa_package.tar.gz -C /temp/root/

# Download post configuration script and make file executable
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/configure-system.sh
chmod 755 /temp/configure-system.sh
# Copy "configure-system.sh" script to "root"
mv /temp/configure-system.sh /temp/root

# Copy netctl wlan0 config file
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/wlan0
cp -rf /temp/wlan0 /temp/root/etc/netctl/

# Replace SSID name
sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAP'/" /temp/root/etc/netctl/wlan0
# Replace SSID password
sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0

# Copy wlan0.service file to systemd and create symlink to make it work at first boot
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/netctl%40wlan0.service
cp -rf /temp/netctl@wlan0.service /temp/root/etc/systemd/system/
ln -s '/temp/root/etc/systemd/system/netctl@wlan0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@wlan0.service'

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
