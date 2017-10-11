#!/bin/bash

username=$1
pwd=$2
docker_ee_url=$3
ipaddress=$4

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
sudo apt-get -y update
sudo usermod -aG docker $username
sudo docker image pull docker/ucp:2.2.3
sudo docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.3 install --admin-username docker --admin-password Docker2017 --host-address $ipaddress
sudo reboot
