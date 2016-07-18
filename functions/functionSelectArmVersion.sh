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

# Download Arch Linux ARM image, check what version ARM v6 or v7
  echo "#########################################################################"
  echo "Download and extract Arch Linux ARM image"
  echo "#########################################################################"
  echo "Download Arch Linux ARM v'$armVersion' and expand to root"
    if [ $armVersion = 6 ]; then
      echo "Downloading Arch Linux ARM v6"
       wget -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
      echo "Download complete, expanding image to root"
       {
       bsdtar -xpf /temp/ArchLinuxARM-rpi-latest.tar.gz -C /temp/root
       sync
       } &> /dev/null
       elif [ $armVersion = 7 ]; then
         echo "Downloading Arch Linux ARM v7"
          wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
         echo "Download complete, expanding image to root"
          {
          bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
          sync
          } &> /dev/null
       elif [ $armVersion = 8 ]; then
         echo "Downloading Arch Linux ARM v8, but the image is still v7 :-("
          wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
         echo "Download complete, expanding image to root"
          {
          bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
          sync
          } &> /dev/null
      else
        echo "'Something went wrong with the arm version selecton... script will exit..."
        exit 1
    fi
  echo "Download and extract complete"

#Move boot files to the first partition:
  mv /temp/root/boot/* /temp/boot
  echo "#########################################################################"
  echo ""
  echo ""
}
