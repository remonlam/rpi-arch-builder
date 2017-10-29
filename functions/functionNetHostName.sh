#!/bin/bash

#########################################################################################
### NOTE: This function will ask the user for a hostname and write it back as a variable.
function functionNetHostName {
  echo "####################################################################################"
  echo "Enter a hostname only, do no include a domain name!;"
  echo "####################################################################################"
    read -p 'Enter a hostname: ' varHostName

  # Change hostname
    sed -i 's/alarmpi/'$varHostName'/' /temp/root/etc/hostname
}
