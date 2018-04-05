#!/bin/bash

#Check root access
if [ "$EUID" -ne 0 ]
  then echo "Run as root"
  exit
fi

#Update & upgrade
apt-get update && apt-get upgrade -y
apt-get install build-essential -y

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
tar xzf "$file"

#Enter file
cd vpnserver
make i_read_and_agree_the_license_agreement
