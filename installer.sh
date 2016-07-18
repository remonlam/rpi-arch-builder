#!/bin/bash

## Import Variables & Functions from external sources
. ./functions/masterVariables.sh
. ./functions/masterFunctions.sh

#########################################################################################
### RUNTIME                                                                           ###
#########################################################################################

# Run functions
functionRootCheck
functionFindSource
functionFormatDisk
functionSelectArmVersion
#functionDisableSystemctlServices #need to chec if this is the right place to execute this function

functionsNetworkProfileSelection
functionSetRootPassword
functionSystemPreConfiguration
functionCleanup
functionShowConfig
