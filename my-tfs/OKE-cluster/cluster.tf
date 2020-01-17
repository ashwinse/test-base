

module "uniqueid" {
  source = "./modules/uniqueid"
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = "${var.compartment_ocid}"
}

resource "oci_core_virtual_network" "virtual_network" {
  display_name   = "vcn${module.uniqueid.unique_id}"
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  dns_label      = "oke"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  display_name   = "internet_gateway${module.uniqueid.unique_id}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"
}

resource "oci_core_route_table" "lb_route_table" {
  display_name   = "lb_route_table${module.uniqueid.unique_id}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.internet_gateway.id}"
  }
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "ngw${module.uniqueid.unique_id}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"
}

resource "oci_core_route_table" "wrkr_route_table" {
  display_name   = "wrkr_route_table${module.uniqueid.unique_id}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_nat_gateway.nat_gateway.id}"
  }
}

resource "oci_core_security_list" "wrkrs_security_list" {
  display_name   = "wrkrs_security_list${module.uniqueid.unique_id}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  egress_security_rules = [{
    protocol    = "All"
    destination = "10.0.0.0/24"
    stateless   = true
  }]

  egress_security_rules = [{
    protocol    = "All"
    destination = "10.0.1.0/24"
    stateless   = true
  }]

  egress_security_rules = [{
    protocol    = "All"
    destination = "10.0.2.0/24"
    stateless   = true
  }]

  egress_security_rules = [{
    protocol    = "All"
    destination = "0.0.0.0/0"
    stateless   = false
  }]

  ingress_security_rules = [{
    protocol  = "All"
    source    = "10.0.0.0/24"
    stateless = true
  }]

  ingress_security_rules = [{
    protocol  = "All"
    source    = "10.0.1.0/24"
    stateless = true
  }]

  ingress_security_rules = [{
    protocol  = "All"
    source    = "10.0.2.0/24"
    stateless = true
  }]

  ingress_security_rules = [{
    protocol  = "6"
    source    = "10.0.0.0/16"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }]
}

resource "oci_core_security_list" "lb_security_list" {
  display_name   = "lb_security_list${module.uniqueid.unique_id}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  egress_security_rules = [{
    protocol    = "6"
    destination = "0.0.0.0/0"
    stateless   = true
  }]

  ingress_security_rules = [{
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
  }]
}

resource "oci_core_subnet" "subnet0" {
  display_name               = "subnet0"
  compartment_id             = "${var.compartment_ocid}"
  availability_domain        = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  cidr_block                 = "10.0.0.0/24"
  vcn_id                     = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id             = "${oci_core_route_table.wrkr_route_table.id}"
  security_list_ids          = ["${oci_core_security_list.wrkrs_security_list.id}"]
  dhcp_options_id            = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
  dns_label                  = "subnet0"
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "subnet1" {
  display_name               = "subnet1"
  compartment_id             = "${var.compartment_ocid}"
  availability_domain        = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[1], "name")}"
  cidr_block                 = "10.0.1.0/24"
  vcn_id                     = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id             = "${oci_core_route_table.wrkr_route_table.id}"
  security_list_ids          = ["${oci_core_security_list.wrkrs_security_list.id}"]
  dhcp_options_id            = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
  dns_label                  = "subnet1"
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "subnet2" {
  display_name               = "subnet2"
  compartment_id             = "${var.compartment_ocid}"
  availability_domain        = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[2], "name")}"
  cidr_block                 = "10.0.2.0/24"
  vcn_id                     = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id             = "${oci_core_route_table.wrkr_route_table.id}"
  security_list_ids          = ["${oci_core_security_list.wrkrs_security_list.id}"]
  dhcp_options_id            = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
  dns_label                  = "subnet2"
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "lbsubnet0" {
  display_name        = "lbsubnet0"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  cidr_block          = "10.0.3.0/24"
  vcn_id              = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id      = "${oci_core_route_table.lb_route_table.id}"
  security_list_ids   = ["${oci_core_security_list.lb_security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
  dns_label           = "lbsubnet0"
}

resource "oci_core_subnet" "lbsubnet1" {
  display_name        = "lbsubnet1"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[1], "name")}"
  cidr_block          = "10.0.4.0/24"
  vcn_id              = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id      = "${oci_core_route_table.lb_route_table.id}"
  security_list_ids   = ["${oci_core_security_list.lb_security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
  dns_label           = "lbsubnet1"
}

data "oci_containerengine_cluster_kube_config" "cluster_kube_config" {
  cluster_id    = "${oci_containerengine_cluster.cluster.id}"
  expiration    = 2592000
  token_version = "2.0.0"
}

resource "local_file" "cluster_kube_config_file" {
  content  = "${data.oci_containerengine_cluster_kube_config.cluster_kube_config.content}"
  filename = "config"
}

resource "oci_containerengine_cluster" "cluster" {
  compartment_id     = "${var.compartment_ocid}"
  kubernetes_version = "${var.oke["version"]}"
  name               = "${var.oke["name"]}${module.uniqueid.unique_id}"
  vcn_id             = "${oci_core_virtual_network.virtual_network.id}"

  options {
    service_lb_subnet_ids = ["${oci_core_subnet.lbsubnet0.id}", "${oci_core_subnet.lbsubnet1.id}"]
  }
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id          = "${oci_containerengine_cluster.cluster.id}"
  compartment_id      = "${var.compartment_ocid}"
  kubernetes_version  = "${var.oke["version"]}"
  name                = "${var.oke["name"]}${module.uniqueid.unique_id}"
  node_image_name     = "Oracle-Linux-7.5"
  node_shape          = "${var.oke["shape"]}"
  subnet_ids          = ["${oci_core_subnet.subnet0.id}", "${oci_core_subnet.subnet1.id}", "${oci_core_subnet.subnet2.id}"]
  quantity_per_subnet = "${var.oke["nodes_per_subnet"]}"
  ssh_public_key      = "${var.ssh_public_key}"
}
