output "usernames_list" {
  value = ["${module.user_groups.user_name}"]
}

output "user_ocids" {
  value = ["${module.user_groups.user_ocids}"]
}

output "ui_passwords_list" {
  value = ["${join(",", formatlist("%q", module.user_groups.user_ui_password))}"]
}

output "compartment_ocid" {
  value = ["${var.compartment_ocid}"]
}

output "tenancy_ocid" {
  value = ["${var.tenancy_ocid}"]
}

output "tenancy_name" {
  value = ["${var.tenancy_name}"]
}

output "compartment_name" {
  value = ["${var.compartment_name}"]
}

output "region" {
  value = ["${var.ociregion}"]
}

