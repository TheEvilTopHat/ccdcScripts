#!/usr/bin/env bash

#choose os 
OS="" #f = fedora, c = cent, d = ubuntu/debian
ports=(80 tcp 443 tcp 22 tcp 55 udp)      #example array0=(80tcp 443udp 88tcp 22udp)
#auto detect package manager/os
declare -A osInfo;
osInfo[/etc/redhat-release]=red
osInfo[/etc/arch-release]=arch
osInfo[/etc/gentoo-release]=gent
osInfo[/etc/SuSE-release]=suse
osInfo[/etc/debian_version]=deb
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo Package manager: ${osInfo[$f]}
	OS=${osInfo[$f]}
	echo $OS
    fi
done
#update the system
#redhat (fedora, cent)
if [ "$OS" == "red" ]
then
	echo "updating with yum";
	yum update;
	echo "done";
fi
#debian ubuntu
if [ "$OS" == "deb" ]
then
        echo "updating with apt-get";
        apt-get update;
	apt-get upgrade;
	apt-get dist-upgrade;
        echo "done";
fi
#suse
if [ "$OS" == "suse" ]
then
        echo "updating with zypper";
        zypper refresh;
        zypper update;
        echo "done";
fi
#arch
if [ "$OS" == "arch" ]
then
        echo "updating with pacman";
        pacman -Syu;
        echo "done";
fi
#gentto
if [ "$OS" == "gent" ]
then
        echo "updating with emerge";
        echo "TODO NOT IMPLEMENTED";
        echo "done";
fi


#create passwords for root and sudo users
password_root=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};)
password_sudo=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};)
echo $password_root
echo $password_sudo
#change all sudo users to this new password
sudos="$(getent group root wheel adm admin sudo | cut -d : -f 4)"
echo $sudos;
sudos=(${sudos//,/ })
echo "root:$password_root" >> firstRun.txt
echo -e "$password_root\n$password_root" | passwd root
for i in "${sudos[@]}"
do
	echo "$i:$password_sudo" >> firstRun.txt
        #change password
        echo -e "$password_sudo\n$password_sudo" | passwd $i
done
#firewall
#redhat (fedora, cent)
if [ "$OS" == "red" ]
then
        echo "updating firewalld"

fi
#ubutud debian
if [ "$OS" != "red" ]
then
	echo "updating iptables";
        #defulat drop
        #ipv4
        iptables -P INPUT DROP
        iptables -P FORWARD DROP
        #ipv6
        sudo ip6tables -P INPUT DROP
        sudo ip6tables -P FORWARD DROP
        sudo ip6tables -P OUTPUT DROP

	#todo
        for ((i=0; i < ${#ports[@]}; i+=2))
        do
        port=${ports[$i]}
        protocal=${ports[$i+1]}
	echo "port:$port"
        echo "protocal:$protocal"
        #firewalld rule add
        iptables -A INPUT -p $protocal --dport $port -j ACCEPT
        done

        #reject all trafic left
        iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
        iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
        iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable

        #save rules
        service iptables-persistent save
fi


#save info
