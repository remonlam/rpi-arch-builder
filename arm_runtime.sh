#!/bin/sh

# Set vars
echo "########################################################################"
echo "NOTE: Select the correct version of ARM is nessesarly for downloading"
echo "      the corresponding version of the Arch ARM Linux image"
echo ""
echo "Select 'arm6' when using models like: PI 1 MODEL A+"
echo "                                    PI 1 MODEL B+"
echo "                                    PI ZERO"
echo ""
echo "Select 'arm7' when using models like: PI 2 MODEL B"
echo ""
echo "Select 'arm8' when using models like: PI 3 MODEL B"
echo "########################################################################"

# Ask user for type or ARM processor
read -p 'What version of ARM?: arm6 / arm7 / arm8: ' armVersion

if [ $armVersion = "arm6" ]; then
  echo "Using ARM version 6"
elif [ $armVersion = "arm7" ]; then
  echo "Using ARM version 7"
elif [ $armVersion = "arm8" ]; then
  echo "Using ARM version 8"
else
   echo "'$armVersion' is an invalid ARM version, should be something like 'arn#'"
   exit 1
fi

echo "Show output of set var '$armVersion'"
