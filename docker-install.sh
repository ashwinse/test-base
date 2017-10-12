#!/bin/bash

username=$1
password=$2


echo -e "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
echo -e "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo usermod -l $username ubuntu
usermod -d /home/$username -m $username

##### Enable 'docker' user to ssh with a password
echo -e "$password\n$password" | sudo passwd $username
file="/etc/ssh/sshd_config"
passwd_auth="yes"
cat $file \
| sed -e "s:\(PasswordAuthentication\).*:PasswordAuthentication $passwd_auth:" \
> $file.new
mv $file.new $file
service sshd restart

#echo -e "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo apt-get -y update
sudo apt-get -y install dnsmasq
echo -e "server=8.8.8.8\nserver=8.8.4.4" | sudo tee -a /etc/dnsmasq.conf
sudo service dnsmasq restart
sudo service networking restart

#### open ports for docker
sudo apt-get purge ufw
sudo apt-get install -y firewalld
sudo systemctl start firewalld
sudo firewall-cmd --add-port=22/tcp --permanent --zone=public
sudo firewall-cmd --add-port=80/tcp --permanent --zone=public
sudo firewall-cmd --add-port=443/tcp --permanent --zone=public
sudo firewall-cmd --add-port=2375/tcp --permanent --zone=public
sudo firewall-cmd --add-port=2376/tcp --permanent --zone=public
sudo firewall-cmd --add-port=2377/tcp --permanent --zone=public
sudo firewall-cmd --add-port=7946/tcp --permanent --zone=public
sudo firewall-cmd --add-port=7946/udp --permanent --zone=public
sudo firewall-cmd --add-port=4789/udp --permanent --zone=public
sudo firewall-cmd --add-port=12376/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12379/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12380/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12381/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12382/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12383/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12384/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12385/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12386/tcp --permanent --zone=public
sudo firewall-cmd --add-port=12387/tcp --permanent --zone=public
sudo firewall-cmd --reload


