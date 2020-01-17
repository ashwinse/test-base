output "group_ocid" {
  value = "${oci_identity_group.group.id}"
}

output "group_name" {
  value = "${oci_identity_group.group.name}"
}
