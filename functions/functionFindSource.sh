#!/bin/bash

#FILE=../functions/iso.txt
read -p "Enter file name: " FILE

. ./functionLocalVsDownload.sh

# Create function call disabled for now.
function functionFindSource {

if [ -f "$FILE" ];
then
   echo "File $FILE exist."
   varCheckForLocalSource="TRUE"
   md5 -q $FILE
   echo "File found..."
   echo $varCheckForLocalSource
else
   echo "File $FILE does not exist" >&2
   varCheckForLocalSource="FALSE"
   echo "File not found..."
   echo $varCheckForLocalSource
fi




#echo $varCheckForLocalSource
#echo $FILE
#echo $1

#if [[ $(md5sum "test.txt") = d41d8cd98f00b204e9800998ecf8427e* ]]
#md5sum -c "d41d8cd98f00b204e9800998ecf8427e" "test.txt"

#if [[ $(md5sum "$test") = d41d8cd98f00b204e9800998ecf8427e* ]]
}


functionFindSource
functionLocalVsDownload