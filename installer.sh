#!/bin/bash

## Import Variables & Functions from external sources
. ./functions/masterVariables.sh
. ./functions/masterFunctions.sh

#########################################################################################
### RUNTIME                                                                           ###
#########################################################################################

# Run functions
functionRootCheck
functionFormatDisk
#functionFindSource # some kind of loop, needs more work!
functionSelectArmVersion
#functionDisableSystemctlServices #need to check if this is the right place to execute this function

functionsNetworkProfileSelection
#functionSetRootPassword # function does not work on Debian
#functionSystemPreConfiguration
functionCleanup
functionShowConfig
