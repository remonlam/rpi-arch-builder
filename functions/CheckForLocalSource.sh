#!/bin/bash
function CheckForLocalSource {
if [ -f "$FILE" ];
then
   echo "File $FILE exist."
   varCheckForLocalSource="true"
else
   echo "File $FILE does not exist" >&2
   varCheckForLocalSource="false"
fi
echo $varCheckForLocalSource
}
