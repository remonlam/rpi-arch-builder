#!bin/bash

# This function will ask the user for a password and writes it back to the "root" mount of the SD disk.
#
# This script have the following dependencies
# - USB/SD mountpoint to "root" $mount_root

function functionSetRootPassword {
read -s -p "Enter root password: " inRootPass
  echo -n root:$inRootPass | sudo chpasswd -c SHA512 -R $mount_root
echo "Root password has been set"
}
