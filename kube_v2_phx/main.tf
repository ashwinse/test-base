resource "oci_identity_group" "group" {
  name        = "${var.group_name}"
  description = "A group managed with terraform"
}
resource "oci_identity_policy" "p" {
  name           = "${oci_identity_group.group.name}-policy"
  description    = "automated terraform users policy"
  compartment_id = "${var.compartment_id}"

  statements = [
    "Allow group ${oci_identity_group.group.name} to ${var.role} virtual-network-family in compartment ${var.compartment_name}",
  ]
}
resource "oci_identity_user" "user" {
  count       = "${var.user_count}"
  name        = "${format("${var.user_name_prefix}%d", count.index + 1)}"
  description = "User managed with Terraform"
}
resource "oci_identity_ui_password" "ui_pwd" {
  count   = "${var.user_count}"
  user_id = "${element(oci_identity_user.user.*.id, count.index)}"
}
resource "oci_identity_user_group_membership" "t" {
  count          = "${var.user_count}"
  compartment_id = "${var.compartment_id}"
  user_id        = "${element(oci_identity_user.user.*.id, count.index)}"
  group_id       = "${oci_identity_group.group.id}"
}
resource "random_id" "unq" {
  keepers     = {}
  byte_length = 2
}
data "oci_identity_availability_domains" "ad" {
  #Required
  compartment_id = "${var.tenancy_ocid}"
}
resource "oci_core_vcn" "vcn" {
  #Required
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.compartment_id}"

  #Optional
  display_name = "${var.vcn_display_name}${random_id.unq.hex}"
  dns_label    = "${var.vcn_dns_label}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }
}
resource "oci_core_internet_gateway" "igw" {
  #Required
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"

  #Optional
  enabled      = true
  display_name = "${var.internet_gateway_display_name}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }
}
resource "oci_core_route_table" "rtb" {
  #Required
  compartment_id = "${var.compartment_id}"

  route_rules {
    #Required
    network_entity_id = "${oci_core_internet_gateway.igw.id}"

    #Optional
    destination = "${var.route_table_route_rules_cidr_block}"
  }

  vcn_id = "${oci_core_vcn.vcn.id}"

  #Optional
  display_name = "${var.route_table_display_name}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }
}

resource "oci_core_subnet" "subnet1" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")}"
  cidr_block          = "${var.subnet_cidr_block}"
  compartment_id      = "${var.compartment_id}"
  security_list_ids   = ["${oci_core_security_list.sl.id}"]
  vcn_id              = "${oci_core_vcn.vcn.id}"

  #Optional
  display_name = "${var.subnet_display_name}${random_id.unq.hex}"
  dns_label    = "${var.subnet_dns_label}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }

  route_table_id = "${oci_core_route_table.rtb.id}"
}

resource "oci_core_subnet" "subnet2" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[1],"name")}"
  cidr_block          = "${var.subnet2_cidr_block}"
  compartment_id      = "${var.compartment_id}"
  security_list_ids   = ["${oci_core_security_list.sl.id}"]
  vcn_id              = "${oci_core_vcn.vcn.id}"

  #Optional
  display_name = "${var.subnet2_display_name}${random_id.unq.hex}"
  dns_label    = "${var.subnet2_dns_label}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }

  route_table_id = "${oci_core_route_table.rtb.id}"
}

resource "oci_core_security_list" "sl" {
  #Required
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"

  #Optional
  display_name = "${var.security_list_display_name}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }

  egress_security_rules = [
    {
      protocol    = "1"
      destination = "0.0.0.0/0"
      stateless   = true

      icmp_options {
        "type" = 3
        "code" = 4
      }
    },
    {
      protocol    = "all"
      destination = "10.7.0.0/16"
    },
    {
      protocol    = "all"
      destination = "0.0.0.0/0"
    },
  ]

  ingress_security_rules = [
    {
      protocol  = "1"
      source    = "0.0.0.0/0"
      stateless = true

      icmp_options {
        "type" = 3
        "code" = 4
      }
    },
    {
      protocol = "all"
      source   = "10.7.0.0/16"
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"

      tcp_options {
        "min" = 22
        "max" = 65535
      }
    },
  ]
}

resource "oci_core_instance" "masterVm" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_id}"
  shape               = "${var.instance_shape}"

  #Optional
  create_vnic_details {
    #Required
    subnet_id = "${oci_core_subnet.subnet1.id}"

    #Optional
    assign_public_ip = "true"

    display_name = "${var.master_create_vnic_details_display_name}${random_id.unq.hex}"

    freeform_tags = {
      "Owner" = "TL"
    }

    hostname_label = "kmaster"
    private_ip     = "${var.master_create_vnic_details_private_ip}"
  }

  display_name = "${var.master_display_name}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.master_custom_bootstrap_file_name))}"
  }

  source_details {
    #Required
    source_id   = "${var.image_id[var.region]}"
    source_type = "image"

    #Optional
    boot_volume_size_in_gbs = "60"
  }

  preserve_boot_volume = false
}

resource "oci_core_instance" "slaveVm" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_id}"
  shape               = "${var.instance_shape}"

  #Optional
  create_vnic_details {
    #Required
    subnet_id = "${oci_core_subnet.subnet1.id}"

    #Optional
    assign_public_ip = "true"

    display_name = "${var.slave_create_vnic_details_display_name}${random_id.unq.hex}"

    freeform_tags = {
      "Owner" = "TL"
    }

    hostname_label = "knode"
    private_ip     = "${var.slave_create_vnic_details_private_ip}"
  }

  display_name = "${var.slave_display_name}${random_id.unq.hex}"

  freeform_tags = {
    "Owner" = "TL"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.slave_custom_bootstrap_file_name))}"
  }

  source_details {
    #Required
    source_id   = "${var.image_id[var.region]}"
    source_type = "image"

    #Optional
    boot_volume_size_in_gbs = "60"
  }

  preserve_boot_volume = false
}

resource "null_resource" "remote-exec1" {
  depends_on = ["oci_core_instance.masterVm"]

  provisioner "file" {
    source      = "./user-data/"
    destination = "$HOME/"

    connection {
      agent       = false
      timeout     = "15m"
      host        = "${oci_core_instance.masterVm.public_ip}"
      user        = "ubuntu"
      private_key = "${(file(var.ssh_private_key))}"
    }
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = "${oci_core_instance.masterVm.public_ip}"
      user        = "ubuntu"
      private_key = "${(file(var.ssh_private_key))}"
    }

    inline = [
      "cat kubeadm_master.sh | tr -d '\r' > kubeadm_master_new.sh",
      "sudo mv  kubeadm_master_new.sh  kubeadm_master.sh",
      "bash kubeadm_master.sh ${var.slave_create_vnic_details_private_ip}  >> /tmp/remote-exec.log 2>&1",
      "sudo rm -rf $HOME/*.*",
      "exit 0",
    ]
  }
}

resource "null_resource" "remote-exec2" {
  depends_on = ["oci_core_instance.slaveVm"]

  provisioner "file" {
    source      = "./user-data/"
    destination = "$HOME"

    connection {
      agent       = false
      timeout     = "15m"
      host        = "${oci_core_instance.slaveVm.public_ip}"
      user        = "ubuntu"
      private_key = "${(file(var.ssh_private_key))}"
    }
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = "${oci_core_instance.slaveVm.public_ip}"
      user        = "ubuntu"
      private_key = "${(file(var.ssh_private_key))}"
    }

    inline = [
      "cat kubeadm_node.sh | tr -d '\r' > kubeadm_node_new.sh",
      "sudo mv  kubeadm_node_new.sh  kubeadm_node.sh",
      "bash kubeadm_node.sh  >> /tmp/remote-exec.log 2>&1",
      "sudo rm -rf $HOME/*.*",
      "exit 0",
    ]
  }
}
