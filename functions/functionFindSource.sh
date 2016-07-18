#!/bin/bash

# Create function call disabled for now.
#function CheckForLocalSource {
###

if [ -f "$FILE" ];
then
   echo "File $FILE exist."
   varCheckForLocalSource="true"
   md5 -q test.txt
   echo"HEIRNIET"
else
   echo "File $FILE does not exist" >&2
   varCheckForLocalSource="false"
fi
echo $varCheckForLocalSource
echo $FILE
echo $1


if [[ $(md5sum "test.txt") = d41d8cd98f00b204e9800998ecf8427e* ]]
md5sum -c "d41d8cd98f00b204e9800998ecf8427e" "test.txt"

if [[ $(md5sum "$test") = d41d8cd98f00b204e9800998ecf8427e* ]]



# To Do;
# - Add check based on md5 file hash
# - make a if file exists than do md5 check

## know hash of test.txt
# 80e8ed47c871c8df9a1a0b9610dc7a52
#md5 -q test.txt
# Disabled function call on line3}
