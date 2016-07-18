#!/bin/bash

function functionRootCheck {
echo "#########################################################################"
echo "THIS SCRIPT NEEDS TO BE RUN AS ROOT, CHECKING..."
if [ `id -u` = 0 ] ; then
        echo "Running as ROOT, continue with script..."
        echo "#########################################################################"
        ### PRE-REQUIREMENTS
        # Check or install wget, tar and badtar
        {
          echo "Install 'wget, bsdtar & tar'"
        yum install -y wget bsdtar tar
        } &> /dev/null
        echo "#########################################################################"
        echo ""
        echo ""
  else
        echo "#########################################################################"
        echo "Not running as ROOT, exit script..."
        echo "#########################################################################"
    exit 1
fi
}
