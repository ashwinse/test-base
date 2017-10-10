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

#### open ports for docker
sudo apt-get purge ufw
sudo apt-get install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=22/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --add-port=2376/tcp --permanent
sudo firewall-cmd --add-port=2377/tcp --permanent
sudo firewall-cmd --add-port=7946/tcp --permanent
sudo firewall-cmd --add-port=7946/udp --permanent
sudo firewall-cmd --add-port=4789/udp --permanent
sudo firewall-cmd --add-port=12376/tcp --permanent
sudo firewall-cmd --add-port=12379/tcp --permanent
sudo firewall-cmd --add-port=12380/tcp --permanent
sudo firewall-cmd --add-port=12381/udp --permanent
sudo firewall-cmd --add-port=12382/udp --permanent
sudo firewall-cmd --add-port=12383/udp --permanent
sudo firewall-cmd --add-port=12384/udp --permanent
sudo firewall-cmd --add-port=12385/udp --permanent
sudo firewall-cmd --add-port=12386/udp --permanent
sudo firewall-cmd --add-port=12387/udp --permanent
sudo firewall-cmd --reload
