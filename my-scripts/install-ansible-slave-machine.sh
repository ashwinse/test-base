#!/bin/sh

#username=$1
username=ansible
#password=$2
password=Password@1234

sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-get install -y python
sudo useradd $username -d /home/$username
echo -e "$password\n$password" | (passwd $username)
echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
usermod -aG sudo $username








