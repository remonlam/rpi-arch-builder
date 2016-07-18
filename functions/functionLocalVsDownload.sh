#!/bin/bash

function functionLocalVsDownload {
if [ "$varCheckForLocalSource" = "TRUE" ]; then
  echo "Using local ISO source, no download required..."
  echo "#########################################################################"
  #functionSelectArmVersion
  echo "fake exec of arm_function"
    elif [ "$varCheckForLocalSource" = "FALSE" ]; then
        echo "No local ISO source found, download is required :-( "
        echo "#########################################################################"
        exit 0
  fi
}
