#!/bin/bash
#########################################################################################
### NOTE: This function will download an Arch ARM Version if necessary, and extract it to
###       the temporary folder
function functionHandleFileCache {
    echo "Downloading $2 Checksum"
    CHECKSUM="`wget -qO- http://os.archlinuxarm.org/os/$1.md5 | awk '{ print $1 }'`"
    DOWNLOADPATH="./downloads/$1"
    DOWNLOADED=false
    echo "Checking Download Cache For $2"
    if [ -e "$DOWNLOADPATH" ]; then
        echo "File Already Downloaded... Checking Checksum"
        DOWNLOADEDCHECKSUM="`md5sum ${DOWNLOADPATH} | awk '{ print $1 }'`"

        if [[ "$CHECKSUM" = "$DOWNLOADEDCHECKSUM" ]]; then
            echo "Valid cached image found";
            DOWNLOADED=true
        else
            echo "Downloaded file DOES NOT match latest checksum."
            echo "This could be because of corruption or an older version"
            while true; do
                read -p "Would you like to download a fresh version? " yn
                case $yn in
                    [Yy]* ) break;;
                    [Nn]* ) DOWNLOADED=true; break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        fi
    fi

    if [ "$DOWNLOADED" = false ] ; then
        echo "Downloading $2..."
        wget -P ./downloads/$1 http://archlinuxarm.org/os/$1
        #wget -c http://archlinuxarm.org/os/$1 -O - | bsdtar -xpf
        sync
        echo "Download complete"
    fi

    echo "Expanding image to root, this may take a few minutes."
    {
       bsdtar -xpf "./downloads/$1" -C /temp/root
       sync
       rm -rf "./downloads/$1"
    } #&> /dev/null
}
