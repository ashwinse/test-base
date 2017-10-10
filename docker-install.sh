#!/bin/bash

username=$1
pwd=$2
docker_ee_url=$3

repo_url=`echo $docker_ee_url | rev | cut -c5- | rev`

sudo usermod -l $username ubuntu
usermod -d /home/$username -m $username

##### Enable 'docker' user to ssh with a password
echo -e "$pwd\n$pwd" | sudo passwd $username
file="/etc/ssh/sshd_config"
passwd_auth="yes"
cat $file \
| sed -e "s:\(PasswordAuthentication\).*:PasswordAuthentication $passwd_auth:" \
> $file.new
mv $file.new $file
service sshd restart

##### Install docker ee
sudo wget -O /home/$username/copy_certs.sh https://raw.githubusercontent.com/mikegcoleman/hybrid-workshop/master/provision_vms/utilities/copy_certs.sh
sudo chmod +x copy_certs.sh
sudo apt-get -y update 
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL $docker_ee_url | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] $repo_url \
$(lsb_release -cs) \
stable-17.06"
sudo apt-get -y update
sudo apt-get -y install docker-ee
sudo usermod -aG docker $username
sudo reboot
