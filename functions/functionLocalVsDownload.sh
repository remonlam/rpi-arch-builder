#!/bin/bash

function functionLocalVsDownload {
if [ "$varCheckForLocalSource" = "TRUE" ]; then
  echo "Using local ISO source, no download required..."
  echo "#########################################################################"
  echo "Download complete, expanding image to root"
   {
   bsdtar -xpf $FILE -C /temp/root
   sync
   #Move boot files to the first partition:
   cp -r /temp/root/boot/* /temp/boot
   rm -rf /temp/root/boot
   } &> /dev/null

    echo "#########################################################################"
    echo ""
    echo ""
    elif [ "$varCheckForLocalSource" = "FALSE" ]; then
        echo "No local ISO source found, download is required :-( "
        echo "#########################################################################"
        functionSelectArmVersion
  fi
}
