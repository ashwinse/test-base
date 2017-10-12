private_ip=$1
public_ip=$2

sudo docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.3 install --admin-username docker --admin-password Docker2017 --host-address $private_ip --san $public_ip
sudo reboot
