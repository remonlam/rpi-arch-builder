## Static IP

read -p 'Use "dhcp" or "static" IP?: ' ipType

# Checkig correct answer
echo "Checking correct anwer"
if [ $ifType=dhcp]; then
  echo "OK, continue"
if [ $ifType=static]; then
  echo "OK, continue"
else
  echo "NOT OK, wrong IP type!"
  echo "Use only "dhcp or static", script will exit..."
  exit 1
fi

# Setting up IP configuration based on anwer of $ipType...
echo "Using IP type: '$ipType'"
  if [ $ipType=dhcp ]; then
    echo "Configuring '$ipType'"
     #wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
     #echo "Download complete, expanding tar.gz to root"
     #bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C root
     #sync
  else
    echo "Configuring '$ipType'"
     #wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
     #echo "Download complete, expanding tar.gz to root"
     #bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
     #sync
  fi
