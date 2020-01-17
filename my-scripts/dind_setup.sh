sudo apt-get update
sudo apt-get install firewalld -y
sudo service firewalld stop
sudo iptables -F
sudo swapoff -a
sudo apt-get update
sudo apt install docker.io -y
sudo usermod -a -G docker ubuntu
sudo apt-get update && sudo apt-get install -y apt-transport-https
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
git clone https://github.com/kubernetes/kubernetes.git
wget https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/master/fixed/dind-cluster-v1.10.sh
cp dind-cluster-v1.10.sh kubernetes
sudo chmod +x kubernetes/dind-cluster-v1.10.sh
sudo service docker restart
sudo ./kubernetes/dind-cluster-v1.10.sh up
sudo chmod 777  $HOME/.kube/config
#`kubectl proxy --address='0.0.0.0' --port=8002 --accept-hosts='.*'` &