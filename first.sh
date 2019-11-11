#choose os 
OS="f" #f = fedora, c = cent, d = ubuntu/debian
#create passwords for root and sudo users
password_root=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};)
password_sudo=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};)
echo $password_root
echo $password_sudo
#change all sudo users to this new password
sudos=$(getent group root wheel adm admin | cut -d : -f 4)
echo $sudos
