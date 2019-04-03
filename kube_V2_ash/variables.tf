variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_id" {}
variable "region" {
  default = "us-ashburn-1"
}
variable "compartment_name" {}
variable "tenancy_name" {}
variable "user_count" {}
variable "group_name" {}
variable "user_name_prefix" {}
variable "role" {}
variable "image_id" {
  type = "map"
  default = {
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaakbj52337rvtttqlxdwcy2woyzbx6oos3fdhfgfo652yc2tdzm7oq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa445ixnfsh47sd7u3bqurourvzlfzefolvob7ojqsis3r53xddbia"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaam7vdwlyxw3yka6d4jjwuy54k6er2zcv4tb2rdkjjvwlg2yag2xfa"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaan6kqoyld5fbh3v5vknxon76fsa5e7efexsazo3llwu3cksujj2qa"
  }
}
/* ------------------- VCN Variables ------------------------ */
variable "vcn_cidr_block" {
  default = "10.7.0.0/16"
}
variable "vcn_display_name" {
  default = "kube-vcn-"
}
variable "vcn_dns_label" {
  default = "kubevcn"
}
variable "internet_gateway_display_name" {
  default = "kube-igw-"
}
variable "route_table_display_name" {
  default = "kube-rtb-"
}
variable "route_table_route_rules_cidr_block" {
  default = "0.0.0.0/0"
}
variable "subnet_cidr_block" {
  default = "10.7.0.0/24"
}
variable "subnet_display_name" {
  default = "kube-sub-"
}
variable "subnet_dns_label" {
  default = "kubesub"
}
variable "subnet2_cidr_block" {
  default = "10.7.1.0/24"
}
variable "subnet2_display_name" {
  default = "kube-sub2-"
}
variable "subnet2_dns_label" {
  default = "kubesub2"
}
variable "security_list_display_name" {
  default = "kube-sl-"
}
variable "instance_shape" {
  default = "VM.Standard2.1"
}
variable "master_create_vnic_details_display_name" {
  default = "kube-nic-"
}
variable "master_create_vnic_details_hostname_label" {
  default = "kubenic"
}
variable "master_create_vnic_details_private_ip" {
  default = "10.7.0.3"
}
variable "master_display_name" {
  default = "kube-master-"
}
variable "master_hostname_label" {
  default = "kubevm"
}
variable "master_custom_bootstrap_file_name" {
  default = "./user-data/set_passwd.sh"
}
variable "slave_create_vnic_details_display_name" {
  default = "kube-nic-"
}
variable "slave_create_vnic_details_hostname_label" {
  default = "kubenic"
}
variable "slave_create_vnic_details_private_ip" {
  default = "10.7.0.4"
}
variable "slave_display_name" {
  default = "kube-slave-"
}
variable "slave_hostname_label" {
  default = "kubevm"
}
variable "slave_custom_bootstrap_file_name" {
  default = "./user-data/set_passwd.sh"
}
variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAoI3G2NvBStynJXG6cXPuT8PlzJVVHUd8v7mAbK2E+d4kdm0pt/1VMWfA5p0UMaLw6vG0ZxEqUoDObHHV18cTTDG95CXXDgiM5mMPepXgeQZpG+TxJ5NJq+Z4IwPt0q6W0L9AYFCg50b7BhO3S/jngYY74kh4T63gNJ/OlUzL8hnOT93Cq+XNBrAZZdzC/k2nqLxJfM/l5EccYGnaGkdm34C4JCacRKTb43CDK9JXe3n7SrahsfeybYWsxfw69gwNj0fxwzPUDeyEsprjqZEjGGR3H58gmFe3+2TN7Bmv6TZK2H3W4EU0yQpWoPpYz0oDmyHHbf3/Ia8Vhgqg0rV3UQ== rsa-key-20171110"
}
variable "ssh_private_key" {
  default = "./user-data/ssh_private_key.pem"
}