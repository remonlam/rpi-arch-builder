#!/bin/bash

# Create function call disabled for now.
function functionFindSource {
. ./functions/functionLocalVsDownload.sh
echo "Mounting an ISO?"
read -p "Enter full location path to source file (to skip this just press ENTER): " FILE
  if [ -f "$FILE" ];
  then
     echo "File $FILE exist."
     varCheckForLocalSource="TRUE"
     #md5 -q $FILE
     echo "File found..."
     echo $varCheckForLocalSource
     functionLocalVsDownload
  else
     echo "File $FILE does not exist" >&2
     varCheckForLocalSource="FALSE"
     echo "File not found..."
     echo $varCheckForLocalSource
     functionLocalVsDownload
  fi
}
