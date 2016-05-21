#Create an Arch Linux ARM (Raspberry Pi - All versions) microSD Card image.
![Raspberry Pi and Arch Linux ARM](/images/rpi_arm_banner.png)

For some reason the Arch Linux community stopped providing an pre-build image for the Raspberry Pi.
However they provide instructions how to build an Arch Linux ARM "image" on the projects website @ (http://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2) however it's still a lot of work to build the image, and no automate options are available like wifi configuration etc.

To make things simple I've created a little script to automate some of the steps.

## What does this script do?
Here's what it does?
  - It will partition the microSD card (one 100MB boot partition and a root partition that consumes the rest of the space) NOTE: it will wipe/remove all data on the SD card!!.
  - It will download the correct version of the Arch Linux ARM image (v6, v7 and when available the v8 version)
  - It extract the image to the microSD card
  - It sets the GPU memory from 64MB to 16MB (so you have more memory available your apps, assume you don't need a desktop)
  - It fixes the rotation issue with the Raspberry Pi 7" screen, check https://github.com/remonlam/rpi-touch-display-fix
  - Installs/extracts "libnl" and "wpa" packages
  - Copy eth0/wlan0 configuration files and create a netctl service for eth0/wlan0
  - Enable root access trough SSH
  - Sets the hostname

What it won't do!
  - Assume the correct drive name for the microSD card, that's up to you!!!

##SD Card Creation
Replace sdX in the following instructions with the device name for the SD card as it appears on your computer.

## Questions
This script will ask you a couple of things;
  - ARM version, this will be either version 6 (all versions except RPI 2B) or version 7 (RPI 2B only).
  - Device name of the microSD card, this could be /dev/sdb, so you need to enter "sdb".
  - Hostname, sounds obvious :-)
  - WiFi access point name
  - WiFI password (PSK)

## Usage
In order to use this scrip you need to download the shell script and make it executable.
...```wget https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/arch_image_builder.sh```
...```chmod 755 arch_image_builder.sh```
Or using GIT
Browse to the directory that you want to use for GIT;
Execute: ...```git clone https://github.com/containerstack/rbi-arch-builder.git```
Browse to ../rpi-arch-builder/ and use the script like; ./install.sh

## Can't get it to work?
Well the script have some dependencies that needs to be in-place in order get it working.
To make things a bit more simple, I have tested it on an CentOS 7 Live distro, so it should work on this version of CentOS.

## Why this script?
This repo contains everything that is needed to create a Arch Linux ARM image for the Raspberry Pi (any Pi version that contains an ARM version 6, 7 or 8).

Why this script, because it's kinda easy to write the image to a microSD card your self!
That's true but with the Pi Zero that's not as easy as with the other Pi models, because the Pi Zero only have on micro USB connector that's in use for WiFi it's not that easy to put a keyboard to the Pi Zero.
For that reason I created this script that make the Pi Zero headless, it will connect to you're WiFi network and setup root access with SSH, so you don't need to attached a KVM to the Pi.

That's all for now ;-)
