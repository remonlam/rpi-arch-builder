#!/bin/sh

# Check if script runs as root, if not exit
echo "THIS SCRIPT NEEDS TO BE RUN AS ROOT, CHECKING...."
if [ `id -u` = 0 ] ; then
        echo "Running as ROOT, continue with script...."
  else
echo "Not running as ROOT exit script...."
exit 1
fi

### SCRIPT VARIABLES
## Ask user for system specific variables
echo "PI 1 MODEL A+, PI 1 MODEL B+, PI ZERO are V6 --- PI 2 MODEL B is V7"
read -p 'What version of Pi? v6 or v7 ' armversion
read -p 'Enter device name (SD-Card): like sdb: ' sdCard
read -p 'Enter wifi name (Accesspoint): ' wifiAP
read -p 'Enter wifi password: ' wifiKey
part1=1
part2=2

# Do some pre-requirements
# Install wget and badtar
yum install -y wget bsdtar
wget -P /tmp https://raw.githubusercontent.com/remonlam/rpi-archlinux/master/configure-system.sh
chmod 755 /tmp/configure-system.sh

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
mkdir boot
mount /dev/$sdCard$part1 boot

#Create and mount the ext4 filesystem:
echo "Create and mount the ext4 filesystem on '$sdCard$part2'"
mkfs.ext4 /dev/$sdCard$part2
mkdir root
mount /dev/$sdCard$part2 root

echo "Download Arch Linux ARM v'$armversion' and expand to root"
  if [ $armversion=6 ]; then
    echo "Downloading Arch Linux ARM v'$armversion'"
     wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
    echo "Download complete, expanding tar.gz to root"
     bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C root
     sync
  else
    echo "Downloading Arch Linux ARM v'$armversion'"
     wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
    echo "Download complete, expanding tar.gz to root"
     bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
     sync
  fi

# NOTE: moved this part to ARMversion selection
#Download and extract the root filesystem (as root, not via sudo):
#wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
#bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C root
#sync

#Move boot files to the first partition:
mv root/boot/* boot
echo '# Change rotation of Pi Screen' >> boot/config.txt
echo lcd_rotate=2 >> boot/config.txt
sed -i 's/gpu_mem=64/gpu_mem=16/' boot/config.txt

# Copy "configure-system.sh" script to "root"
mv /tmp/configure-system.sh root

# Download Wi-Fi files from GitHub
### TODO: CHECK PATHS TO MOUNT POINT!!
wget -P root/etc/systemd/network/wlan0.network https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/wlan0.network
wget -P root/etc/systemd/system/wpa_supplicant.service https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/wpa_supplicant.service
wget -P root/etc/wpa_supplicant/wlan0.conf https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/wlan0.conf
sed -i 's/AccessPointName/'$wifiAP'/' root/etc/wpa_supplicant/wlan0.conf
sed -i 's/TopSecretPassword/'$wifiKey'/' root/etc/wpa_supplicant/wlan0.conf

# Do a final sync, and wait 5 seconds before unmouting
sync
echo "Wait 5 seconds before unmouting 'boot' and 'root' mount points"
sleep 5

#Unmount the two partitions:
umount boot root
