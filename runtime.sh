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


### SET BASIC SCRIPT VARIABLES
## Ask user for system specific variables
#echo "NOTE: PI 1 MODEL A+, PI 1 MODEL B+, PI ZERO are 6 --- PI 2 MODEL B is 7"
#read -p 'What version of Pi? 6 or 7 ' armVersion
#read -p 'Enter device name (SD-Card): like sdb: ' sdCard
#read -p 'Enter a new hostname: ' hostName
#read -p 'Enter wifi name (Accesspoint): ' wifiAP
#read -p 'Enter wifi password: ' wifiKey
#part1=1
#part2=2
networkType="wifi"


# Check what type of networking is used
echo "Check what network type is used: '$networkType'"
  if [ $networkType=wifi ]; then
    echo "Using Wi-Fi networking"
     ping google.nl
  else if [ $networkType=cable ]; then
        echo "Using Ethernet/cable networking"
     ping containerstack.io
  fi
echo "Done for today"



# Exit script
exit 0
