output "usernames_list" {
  value = ["${oci_identity_user.user.*.name}"]
}

output "ui_passwords_list" {
  value = ["${join(",", formatlist("%q", "${oci_identity_ui_password.ui_pwd.*.password}"))}"]
}

output "user_ocids" {
  value = ["${oci_identity_user.user.*.id}"]
}

output "tenancy_name" {
  value = ["${var.tenancy_name}"]
}

output "compartment_name" {
  value = ["${var.compartment_name}"]
}

output "master_IP" {
  value = [
    "${oci_core_instance.masterVm.public_ip}",
  ]
}

output "slave_IP" {
  value = [
    "${oci_core_instance.slaveVm.public_ip}",
  ]
}

output "master_slave_userName" {
  value = [
    "ubuntu",
  ]
}

output "master_slave_passwd" {
  value = [
    "Password@1234",
  ]
}

/* output "Loadbalancer_IP" {
  value = [
    "${oci_load_balancer_load_balancer.lb.ip_addresses}"
  ]
} */

