#!/bin/bash

#########################################################################################
### NOTE: This function will check if the Arch Linux image is present on the disk
function functionCheckForImage {
  FILE="ArchLinuxARM-rpi-latest.tar.gz"
  if [ -f "$FILE" ];
    then
       echo "File $FILE exist."
    else
       echo "File $FILE does not exist" >&2
  fi
}
