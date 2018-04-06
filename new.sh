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

#Enter file and setting up
cd vpnserver
make i_read_and_agree_the_license_agreement
cd ..
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpnserver
chmod 700 vpncmd
mkdir /var/lock/subsys
touch /etc/init.d/vpnserver
cat > /etc/init.d/vpnserver <<EOF
#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
EOF
mkdir /var/lock/subsys
chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start
update-rc.d vpnserver defaults
