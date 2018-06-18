#!/bin/bash

function functionSystemPreConfiguration {
# System configuration
  echo "#########################################################################"
  echo "System pre-configuration"
  echo "#########################################################################"
# Change rotation of Pi Screen' >> /temp/boot/config.txt
  echo lcd_rotate=2 >> /temp/boot/config.txt
# Change GPU memory from 64MB to 16MB
  sed -i 's/gpu_mem=64/gpu_mem=16/' /temp/boot/config.txt
# Enable root logins for sshd
  sed -i "s/"#"PermitRootLogin prohibit-password/PermitRootLogin yes/" /temp/root/etc/ssh/sshd_config ### <--- FIX ME!!!!
# Download post configuration script and make file executable
  {
  wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/sources/configure-system.sh ### <--- FIX ME!!!!
  chmod 755 /temp/configure-system.sh
  } &> /dev/null
# Copy "configure-system.sh" script to "root"
  mv /temp/configure-system.sh /temp/root
  echo "#########################################################################"
  echo ""
  echo ""
}
