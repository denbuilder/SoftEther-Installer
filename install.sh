#!/bin/bash

#Check root access
if [ "$EUID" -ne 0 ]
  then echo "Run as root"
  exit
fi

#Script Update
LATESTVER="`wget -qO- https://pastebin.com/raw/j37mfrbk`"
VER="0.1"
if [ "$VER" = "$LATESTVER" ]
then
  echo "Running Latest Script"
else
  echo "Not Running Latest Script"
  echo -n "Update Script?"
  read answer
  if ["$answer" | grep -iq "^y" ];then
    echo update
  else
    echo ignore
  fi
fi

#Update & upgrade
apt-get update && apt-get upgrade -y
apt-get install build-essential -y
apt-get install lib32ncurses5-dev -y

#Get architecture
architecture=`getconf LONG_BIT`
if [ "$architecture" -eq 64 ];
then
        arch="64bit_-_Intel_x64_or_AMD64"
        arch2="x64-64bit"
elif [ "$architecture" -eq 32 ];
then
        arch="32bit_-_Intel_x86"
        arch2="x86-32bit"
fi

#File version
version="v4.25-9656-rtm-2018.01.15" #Release Date: 2018-01-15
file="softether-vpnserver-"$version"-linux-"$arch2".tar.gz"

#File download
link="http://www.softether-download.com/files/softether/"$version"-tree/Linux/SoftEther_VPN_Server/"$arch"/"$file
wget $link
tar xzf $file
rm $file

#Enter file and installing
cd vpnserver
make i_read_and_agree_the_license_agreement
cd ..
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpnserver
chmod 700 vpncmd
wget -O /etc/init.d/vpnserver https://raw.githubusercontent.com/denbuilder/softether_script/master/vpnserver?token=AKYThRb_Wq_o619ke03Ccx9P2qkSSwowks5a0F1BwA%3D%3D
mkdir /var/lock/subsys
chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start
update-rc.d vpnserver defaults

#Clear terminal to make look good
history -c
clear
