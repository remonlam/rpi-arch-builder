#!/bin/bash
function CheckForLocalSource {
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


# To Do;
# - Add check based on md5 file hash
# - make a if file exists than do md5 check

## know hash of test.txt
# 80e8ed47c871c8df9a1a0b9610dc7a52

md5 -q test.txt

}
