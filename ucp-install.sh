"sudo docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.3 install --admin-username docker --admin-password Docker2017 --host-address ${data.oci_core_vnic.lin-nic-c.private_ip_address} --san ${data.oci_core_vnic.lin-nic-c.public_ip_address}",
"sudo reboot"
