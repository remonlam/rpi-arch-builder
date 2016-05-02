if [ -s /temp/ArchLinuxARM-rpi-latest.tar.gz ]
then
   echo "File is available"
else
      echo "File is not available"
fi



echo "Download Arch Linux ARM v'$armVersion' and expand to root"
  if [ $armVersion=6 ]; then
    echo "Check if file exist locally"
    if [ -s /temp/ArchLinuxARM-rpi-latest.tar.gz ]
    then
       echo "File is available"
    else
          echo "File is not available"
    fi
  else
    echo "Downloading Arch Linux ARM v'$armVersion'"
     #{
     wget  -P /temp/ http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
     #} &> /dev/null
    echo "Download complete, expanding tar.gz to root"
     {
     bsdtar -xpf /temp/ArchLinuxARM-rpi-2-latest.tar.gz -C /temp/root
     sync
     } &> /dev/null
  fi
echo "Download and extract complete"
