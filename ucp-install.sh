docker_ee_url=$1
private_ip=$2
public_ip=$3

repo_url=`echo $docker_ee_url | rev | cut -c5- | rev`

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
sudo docker image pull docker/dtr:2.3.3
sudo docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.3 install --admin-username docker --admin-password Docker2017 --host-address $private_ip --san $public_ip
sudo reboot
