#Create an Arch Linux ARM (Raspberry Pi Zero) microSD Card image.
![Raspberry Pi Zero, Arch Linux ARM & Docker](/images/arch_pizero_docker_logo.png)

For some reason ArchLinux community stop providing an pre-build image for the Raspberry Pi.
The instructions bellow are straight form there website @ (http://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2).

To make things simple I've created a little script to automate some of the steps.
It's been tested on CentOS 7 but it could run on other Linux systems as well.

And if you're really lazy you could also use the .IMG file that can be found over here.

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
```wget https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/arch_image_builder.sh```
```chmod 755 arch_image_builder.sh```

## Can't get it to work?
Well the script have some dependencies in order to work.
To make things a bit simple I have tested it on an CentOS 7 Live distro, so it should work on this version of CentOS.

## Why this script?
This repo contains everything that is needed to create a Arch Linux ARM image for the Raspberry Pi Zero (or any other Pi with ARM version 6).

Why this script, because it's kinda easy to write the image to a microSD card your self!
That's true but with the Pi Zero that's not as easy as with the other Pi models, because the Pi Zero only have on micro USB connector that's in use for WiFi it's not that easy to put a keyboard to the Pi Zero.
For that reason I created this script that make the Pi Zero headless, it will connect to you're WiFi network and setup root access with SSH, so you don't need to attached a KVM to the Pi.

That's all for now ;-)
