#!/bin/sh

# Set vars
read -p 'wifi/cable/both: ' networkType


# Check what type of networking is used
echo "Check what network type is used: '$networkType'"
if [ $networkType = "wifi" ]; then
  echo "Using Wi-Fi networking"
   ping google.nl
elif [ $networkType = "cable" ]; then
  echo "Using Ethernet/cable networking"
   ping containerstack.io
elif [ $networkType = "both" ]; then
 echo "Using both Wi-Fi and Ethernet networking"
  ping nu.nl
else
   echo "'$networkType'= Invalid variable: ....Go home your drunk.. :-)"
   exit 1
fi
echo "Go home your drunk.. :-)"
