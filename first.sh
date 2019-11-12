#choose os 
OS="" #f = fedora, c = cent, d = ubuntu/debian
#auto detect package manager
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
sudos=$(getent group root wheel adm admin | cut -d : -f 4)
echo $sudos
