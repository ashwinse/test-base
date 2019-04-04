#!/bin/bash
node_privateip=$1
node_host=$2
sudo apt-get update
sudo apt-get install -y firewalld
sudo service firewalld stop
sudo iptables -F
sudo swapoff -a
sudo apt-get update
sudo apt install -y docker.io
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
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#sudo sysctl net.bridge.bridge-nf-call-iptables=1 
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml

sudo kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
sudo kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

    
sudo chmod 0400 $HOME/ssh_private_key.pem
#sudo ssh -i $HOME/ssh_private_key.pem  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@$node_privateip  while [ ! -f /tmp/true ] do sleep 2 done
a=`kubeadm token create --print-join-command`
sleep 150
#sudo kubectl create -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml
ssh -i $HOME/ssh_private_key.pem  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@$node_privateip sudo $a
kubectl label node knode node-role.kubernetes.io/worker=node
