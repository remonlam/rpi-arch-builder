#!/bin/bash



# Create function call disabled for now.
function functionFindSource {
. ./functions/functionLocalVsDownload.sh
echo "Mounting an ISO?"
read -p "Enter file name: (default skip)" FILE
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




#echo $varCheckForLocalSource
#echo $FILE
#echo $1

#if [[ $(md5sum "test.txt") = d41d8cd98f00b204e9800998ecf8427e* ]]
#md5sum -c "d41d8cd98f00b204e9800998ecf8427e" "test.txt"

#if [[ $(md5sum "$test") = d41d8cd98f00b204e9800998ecf8427e* ]]
}
