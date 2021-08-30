#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Please run this script as root" 1>&2
	exit 1
fi

echo
echo -e "The purpose of this script is to automate the upgrade from a Debian 10 server (Buster) to Debian 11 (Bullseye)."
echo -e "Buster's EOL is around August 2022 !"
echo
echo -e "Before upgrading your server, \033[1ma backup is strongly recommended\033[0m in case of problems happening during the upgrade !"
echo
echo -e "Actual Debian version : "
cat /etc/debian_version
echo
echo -e "Actual kernel version : "
uname -mrs
echo

echo -e "Making sure your system is up to date before doing the upgrade..."
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y

read -rp "Do you need to reboot the machine to apply kernel and security updates ? (yY/nN) " answer
case ${answer:0:1} in
	y|Y )
		echo "The system will now reboot !"
		echo
		echo "3..."
		sleep 1
		echo "2..."
		sleep 1
		echo "1..."
		sleep 1
		reboot
	;;
	* )
		echo "Upgrading to Debian 11..."
		sleep 1
	;;
esac

echo -e "Saving the current \"sources.list\" file and sources.list.d directory..."
cp -v /etc/apt/sources.list /root/
cp -rv /etc/apt/sources.list.d/ /root/

#Variables to replace
var1=' buster'
var2='buster/updates'
var3='buster-updates'

#New variables
rep1=' bullseye'
rep2='bullseye-security'
rep3='bullseye-updates'

sed -i "s|$var1|$rep1|g" /etc/apt/sources.list
sed -i "s|$var2|$rep2|g" /etc/apt/sources.list
sed -i "s|$var3|$rep3|g" /etc/apt/sources.list

sudo apt update -y
sudo apt upgrade -y
sudo apt full-upgrade -y

echo
echo -e "Upgrade will be applied after reboot. Make sure it worked by doing \"cat /etc/debian_version\" and \"uname -mrs\""
sleep 2

echo
echo -e "The system will now reboot !"
echo
echo -e "3..."
sleep 1
echo -e "2..."
sleep 1
echo -e "1..."
sleep 1
reboot

