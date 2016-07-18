#!/bin/bash

## Master function script
## this script will call all functions in this directory

## This is just a master test script it wont be used for something :-)
. ./functions/masterVariables.sh

# Import other functions
. ./functions/setRootPassword.sh
. ./functions/formatDisk.sh
. ./functions/functionFindSource.sh
