#!/bin/bash

cd ~opc

curl https://raw.githubusercontent.com/sysgain/oci-terraform-templates/datastax-custom/userdata/lcm_opscenter.sh > lcm_opscenter.sh

chmod +x lcm_opscenter.sh

