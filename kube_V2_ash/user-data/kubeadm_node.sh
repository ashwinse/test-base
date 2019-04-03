#!/bin/bash
#node_privateip=$1
sudo apt-get update
sudo apt-get install firewalld -y
sudo service firewalld stop
sudo iptables -F
sudo swapoff -a
sudo apt-get update
sudo apt install docker.io -y
sudo usermod -a -G docker ubuntu
sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch  /etc/apt/sources.list.d/kubernetes.list
sudo chmod 777  /etc/apt/sources.list.d/kubernetes.list
sudo cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo touch /tmp/true
#sleep 200
#sudo chmod 0400 $HOME/ssh_private_key.pem
#a=`ssh -i $HOME/ssh_private_key.pem  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@$node_privateip kubeadm token create --print-join-command`
#b=`sudo $a`

