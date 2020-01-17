#!/bin/sh

#username=$1
username=ansible
#password=$2
password=Password@1234

sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-get install -y python
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
sudo useradd $username
echo -e "$password\n$password" | (passwd $username)
echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
usermod -aG sudo $username



echo 'chefuser ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers


