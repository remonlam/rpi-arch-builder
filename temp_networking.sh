### NETWORKING
## Download extra sources and merge it
# Download "libnl" and "wpa_supplicant" package tar.gz file from GitHub
wget -P /temp/ https://github.com/remonlam/rpi-zero-arch/raw/master/packages/libnl_wpa_package.tar.gz
# Extract tar.gz file to root/
tar -xf /temp/libnl_wpa_package.tar.gz -C /temp/root/

# Download post configuration script and make file executable
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/configure-system.sh
chmod 755 /temp/configure-system.sh
# Copy "configure-system.sh" script to "root"
mv /temp/configure-system.sh /temp/root

# Copy netctl wlan0 config file
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/wlan0
cp -rf /temp/wlan0 /temp/root/etc/netctl/

# Copy wlan0.service file to systemd and create symlink to make it work at first boot
wget -P /temp/ https://raw.githubusercontent.com/remonlam/rpi-zero-arch/master/systemd_config/netctl%40wlan0.service
cp -rf /temp/netctl@wlan0.service /temp/root/etc/systemd/system/
ln -s '/temp/root/etc/systemd/system/netctl@wlan0.service' '/temp/root/etc/systemd/system/multi-user.target.wants/netctl@wlan0.service'




## Check if DHCP or FIXED IP needs to be configured
echo "##############################################################"
echo "Check if DHCP or FIXED IP needs to be configured"
echo "**************************************************************"
echo "This let's you choose between Wi-Fi, Ethernet or both of them"
echo "##############################################################"
if [ "$wifiIpType" = "FIXED" ]; then
  echo "Setup Fixed IP settings for: '$networkType'"
    read -p 'Enter IP Address: ' networkWifiIP
    read -p 'Enter IP Subnet, example: /24: ' networkWifiSubnet
    read -p 'Enter Gateway: ' networkWifiGateway
    read -p 'Enter DNS 1: ' networkWifiDns1
    read -p 'Enter DNS 2: ' networkWifiDns2
      ###
      # Replace DHCP to STATIC
      sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
      sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
      sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
      sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
      ###
elif [ "$ethernetIpType" = "FIXED" ]; then
  echo "Setup Fixed IP settings for: '$networkType'"
    read -p 'Enter IP Address: ' networkEthernetIP
    read -p 'Enter IP Subnet: ' networkEthernetSubnet
    read -p 'Enter Gateway: ' networkEthernetGateway
    read -p 'Enter DNS 1: ' networkEthernetDns1
    read -p 'Enter DNS 2: ' networkEthernetDns2
elif [ "$networkType" = "both" ]; then
  echo "Setup Fixed IP settings for: Wi-Fi"
  echo "###########################################"
    read -p 'Enter IP Address: ' networkWifiIP
    read -p 'Enter IP Subnet: ' networkWifiSubnet
    read -p 'Enter Gateway: ' networkWifiGateway
    read -p 'Enter DNS 1: ' networkWifiDns1
    read -p 'Enter DNS 2: ' networkWifiDns2
    ###
    # Replace DHCP to STATIC
    sed -i "s/IP=dhcp/IP=static/" /temp/root/etc/netctl/wlan0
    sed -i "/IP=static/ a Address=('$networkWifiIP/$networkWifiSubnet')" /temp/root/etc/netctl/wlan0
    sed -i "/Address=/ a Gateway=('$networkWifiGateway')" /temp/root/etc/netctl/wlan0
    sed -i "/Gateway=/ a DNS=('$networkWifiDns1' '$networkWifiDns2')" /temp/root/etc/netctl/wlan0
    ###
  echo "Setup Fixed IP settings for: Ethernet"
  echo "###########################################"
    read -p 'Enter IP Address: ' networkEthernetIP
    read -p 'Enter IP Subnet: ' networkEthernetSubnet
    read -p 'Enter Gateway: ' networkEthernetGateway
    read -p 'Enter DNS 1: ' networkEthernetDns1
    read -p 'Enter DNS 2: ' networkEthernetDns2
else
  echo "You're selected DHCP so no IP settings needs to be configured"
fi
echo "###########################################"
echo "IP type selection has been set correctly..."
echo "###########################################"
echo ""
echo ""






# Replace SSID name
sed -i "s/ESSID='SSID-NAME'/ESSID='$wifiAP'/" /temp/root/etc/netctl/wlan0
sed -i "s/Key='SSID-KEY'/Key='$wifiKey'/" /temp/root/etc/netctl/wlan0
