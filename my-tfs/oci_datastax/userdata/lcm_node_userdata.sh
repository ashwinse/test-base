#!/usr/bin/env bash

cd ~opc

curl https://raw.githubusercontent.com/sysgain/oci-terraform-templates/datastax-custom/userdata/lcm_node.sh > lcm_node.sh

chmod +x lcm_node.sh

