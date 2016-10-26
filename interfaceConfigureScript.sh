#!bin/bash

#Display help

if [ "$1" == "--help" ]; then
	echo "sudo ./$0 <interface> <ip> <netmask> <gateway> <dns>"
	exit
fi

#Check if the user is root.

if [ $UID -ne 0 ]; then
	echo "This script needs root privileges to be executed."
	exit
fi

#Check the arguments

python checkIP.py "$2"
if [ $? -ne 0 ]; then
	echo "Invalid IP address."
	exit
fi

python checkIP.py "$3"
if [ $? -ne 0 ]; then
	echo "Invalid netmask."
	exit
fi

python checkIP.py "$4"
if [ $? -ne 0 ]; then
	echo "Invalid gateway."
	exit
fi

python checkIP.py "$5"
if [ $? -ne 0 ]; then
	echo "Invalid DNS."
	exit
fi

#Check if the interface is already configured as dhcp and change it to static.

grep -q "iface $1 inet dhcp" /etc/network/interfaces

if [ $? -eq 0 ]; then
	sed -i "s/iface $1 inet dhcp/iface $1 inet static/g" /etc/network/interfaces
else
	echo
	echo "auto $1" >> /etc/network/interfaces
	echo "iface $1 inet static" >> /etc/network/interfaces
fi

#Configure the address, netmask, gateway and dns.

	echo "address $2" >> /etc/network/interfaces
	echo "netmask $3" >> /etc/network/interfaces
	echo "gateway $4" >> /etc/network/interfaces
	echo "dns-nameserver $5" >> /etc/network/interfaces
