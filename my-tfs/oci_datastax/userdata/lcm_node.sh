#!/bin/bash

##### Collecting input params
opsc_ip=$1
cluster_name=$2
data_center_name=$3
data_center_size=$4
db_passwd=$5
opc_passwd="datastax1!"

echo In lcm_node.sh
echo opsc_ip = $opsc_ip
echo cluster_name = $cluster_name
echo data_center_name = $data_center_name
echo data_center_size = $data_center_size

##### Turn off the firewall
service firewalld stop
chkconfig firewalld off


##### Enable 'opc' user to ssh with a password
echo $opc_passwd | sudo passwd --stdin opc

file="/etc/ssh/sshd_config"
passwd_auth="yes"
cat $file \
| sed -e "s:\(PasswordAuthentication\).*:PasswordAuthentication $passwd_auth:" \
> $file.new
mv $file.new $file

service sshd restart 


##### Mount disks
# Install LVM software:
yum -y update
yum -y install lvm2 dmsetup mdadm reiserfsprogs xfsprogs

# Create disk partitions for LVM:
pvcreate /dev/nvme0n1 /dev/nvme1n1 

# Create volume group upon disk partitions:
vgcreate vg-nvme /dev/nvme0n1 /dev/nvme1n1 
lvcreate --name lv --size 5.8T vg-nvme
mkfs.ext4 /dev/vg-nvme/lv
mkdir /mnt/data1
mount /dev/vg-nvme/lv /mnt/data1
mkdir -p /mnt/data1/data
mkdir -p /mnt/data1/saved_caches
mkdir -p /mnt/data1/commitlog
chmod -R 777 /mnt/data1


##### Install DSE the LCM way 
yum -y install unzip wget
#wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-9.noarch.rpm
rpm -ivh epel-release-7-9.noarch.rpm
yum -y install python-pip
pip install requests

public_ip=`curl --retry 10 icanhazip.com`
private_ip=`echo $(hostname -I)`
node_id=$private_ip
rack="rack1"

cd ~opc
release="5.5.6"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.zip
unzip $release.zip
cd install-datastax-ubuntu-$release/bin/lcm/

./addNode.py \
--opsc-ip $opsc_ip \
--clustername $cluster_name \
--dcsize $data_center_size \
--dcname $data_center_name \
--rack $rack \
--pubip $public_ip \
--privip $private_ip \
--nodeid $node_id \
--dbpasswd $db_passwd


