#!/bin/bash

#########################################################################################
### NOTE: This function unmount disk and cleanup /temp/.
###
function functionCleanup {
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
