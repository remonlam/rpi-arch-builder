#/bin/bash

wget https://www.libarchive.org/downloads/libarchive-3.3.1.tar.gz
tar xzf libarchive-3.3.1.tar.gz
cd libarchive-3.3.1
./configure
make
sudo make install
