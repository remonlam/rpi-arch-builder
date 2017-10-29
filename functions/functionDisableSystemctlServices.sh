#!/bin/bash

#########################################################################################
### NOTE: This function will remove the SystemctlNetwork and SystemctlDNS services -
###       to prevent DHCP from kicking in during boot and make DNS to point to the -
###       configured addresses.
function functionDisableSystemctlServices {
# Remove SystemctlNetwork
rm /temp/root/etc/systemctl/../../../

# Remove Systemctl-DNS
rm /temp/root/etc/systemctl/../../../
}
