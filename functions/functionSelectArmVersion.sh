#!/bin/bash
#########################################################################################
### NOTE: This function will select the correct Arch Linux ARM version, download and -
###       extract the image to the SD card.
function functionSelectArmVersion {
# Ask user for system specific variables
  echo "#########################################################################"
  echo "NOTE: Select the correct version of ARM is nessesarly for downloading"
  echo "      the corresponding version of the Arch ARM Linux image"
  echo ""
  echo "Select 'ARM v6' when using models like:  PI 1 MODEL A+"
  echo "                                         PI 1 MODEL B+"
  echo "                                         PI ZERO"
  echo "                                         PI ZERO W"
  echo ""
  echo "Select 'ARM v7' when using models like:  PI 2 MODEL B"
  echo ""
  echo "Select 'ARM v8' when using models like:  PI 3 MODEL B"
  echo "#########################################################################"
  echo ""
  echo ""

# Ask user for type or ARM processor
  echo "Select version of the correct ARM version, see info above for more information;"
  echo "####################################################################################"
  select yn in "ARM v6" "ARM v7" "ARM v8"; do
      case $yn in
          'ARM v6' ) armVersion="6"; break;;
          'ARM v7' ) armVersion="7"; break;;
          'ARM v8' ) armVersion="8"; break;;
   esac
  done
    echo "armversion=${armVersion}" > ./armversion
# Download Arch Linux ARM image, check what version ARM v6, v7 or v8
  echo "#########################################################################"
  echo "Download and extract Arch Linux ARM image"
  echo "#########################################################################"
  mkdir -p downloads

# Import function;
  . ./functions/functionHandleFileCache.sh

    FILENAME=false
    NAME=false
    if [ $armVersion = 6 ]; then
        FILENAME="ArchLinuxARM-rpi-latest.tar.gz"
        NAME="Arch Linux ARM v6"
    elif [ $armVersion = 7 ]; then
        FILENAME="ArchLinuxARM-rpi-2-latest.tar.gz"
        NAME="Arch Linux ARM v7"
    elif [ $armVersion = 8 ]; then
        FILENAME="ArchLinuxARM-rpi-3-latest.tar.gz"
        NAME="Arch Linux ARM v8"
    fi

    if [ "$FILENAME" = false ] ; then
        echo "'Something went wrong with the arm version selection... script will exit..."
        exit 1
    else
        functionHandleFileCache "$FILENAME" "$NAME"
    fi

  echo "Download and extract complete"

#Move boot files to the first partition:
  cp -r /temp/root/boot/* /temp/boot
  rm -rf /temp/root/boot
  echo "#########################################################################"
  echo ""
  echo ""
}
