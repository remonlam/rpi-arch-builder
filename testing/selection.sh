#!/bin/sh

echo "Do you wish to install the VMware Tools on this Linux virtual machine?"
echo "####################################################################################"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo; break;;
        No ) exit;;
    esac
done

echo "Select version of CentOS or Fedora"
echo "####################################################################################"
select yn in "CentOS 5" "CentOS 6" "CentOS 7" "Fedora 21"; do
    case $yn in
        'CentOS 5' ) OS_VERSION="centos5"; break;;
        'CentOS 6' ) OS_VERSION="centos6"; break;;
        'CentOS 7' ) OS_VERSION="centos7"; break;;
        'Fedora 21') OS_VERSION="fedora21"; break;;
 esac
done
