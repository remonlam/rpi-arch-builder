#!/bin/bash
FILE="$1"

if [ -f "$FILE" ];
then
   echo "File $FILE exist."
   varCheckForLocalSource="true"
else
   echo "File $FILE does not exist" >&2
   varCheckForLocalSource="false"
fi
echo $varCheckForLocalSource
