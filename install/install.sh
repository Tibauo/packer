#!/bin/bash
set -x 
user=${1:-root}
path_home_user=${2:-/root}
version=${3:-1.3.5}
zip=packer_${version}_linux_amd64.zip
link=https://releases.hashicorp.com/packer/$version/packer_${version}_linux_amd64.zip
install_dir=/usr/local/bin/

HOME_DIR=$PWD
echo "HOME_DIR=$HOME_DIR"

usage(){
cat <<EOF
Need to be sudoer or root

How to use
----------
$PROGNAME

EOF
exit 1
}

requiredInstallYum(){
  yum update -y
  yum install -y epel-release unzip wget
}

requiredInstallApt(){
  apt update -y
  apt install -y wget unzip vim
}

createUser(){
if [ -z $(id -u $user) ]; then
  echo "user $user doesn't exist"
  useradd -m $user -s /bin/bash
  echo "user $user created"
fi

if [ -f $path_home_user ]; then
  echo "home directory $path_home_directory for $user doesn't exist"
  usage
fi
}

installPacker(){
wget $link -P /tmp/
unzip /tmp/$zip -d /usr/local/bin
}

installScriptsPacker(){
  cp -R $HOME_DIR/scripts $path_home_user/
  chown -R $user $path_home_user/scripts
}


main(){

if [ -n "$(command -v yum)" ]; then
  echo "Yum"
  requiredInstallYum
elif [ -n "$(command -v apt-get)" ]; then
  echo "Apt"
  requiredInstallApt
else
  echo [ "don't know" ]
  usage
fi

createUser
installPacker
installScriptsPacker
}

while getopts ":h" option; do
    case "${option}" in
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  usage
fi

main
