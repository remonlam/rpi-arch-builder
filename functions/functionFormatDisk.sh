#!/bin/bash

#########################################################################################
### NOTE: This function will format the disk, create new partitions / filesystem -
###       Mount it to /temp/boot & /temp/root.
function functionFormatDisk {
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
    mkdir -p /temp/boot # make a variable of this mountpint $mount_boot
    mount /dev/$sdCard$part1 $mount_boot
  } &> /dev/null
  echo ""

  echo "Create and mount the ext4 filesystem on '$sdCard$part2'"
  {
    mkfs -t ext4 /dev/$sdCard$part2
    mkdir -p /temp/root
    mount /dev/$sdCard$part2 $mount_root # make a variable of this mountpint $mount_root
  } &> /dev/null
  echo "#########################################################################"
  echo ""
  echo ""
}
