#!/bin/bash

function checkImage {


function test {
  ifconfig
}

echo "Do you want to use an existing Arch Linux ARM image?"
echo "####################################################################################"
select yn in "Use a existing image" "Download the correct image"; do
    case $yn in
        'Use a existing image' ) downloadImage="FALSE"; break;;
        'Download the correct image' ) downloadImage="TRUE"; break;;
 esac
done
echo "DEBUG: show downloadImage: " $downloadImage

if [ $downloadImage = FALSE ]; then
  echo "Using local existing image"
  read -p 'Enter full path to image file, including image name!: ' fileName
      if [ -f "$fileName" ];
        then
           echo "File $fileName exist."
           test
        else
           echo "File $fileName does not exist" >&2
           echo "Failed to find image, script will exit..."
           exit 1
      fi
  elif [ $downloadImage = TRUE ]; then
      echo "Download new image..."
  else
    echo "'Something went wrong with the arm version selecton... script will exit..."
fi

}

checkImage
