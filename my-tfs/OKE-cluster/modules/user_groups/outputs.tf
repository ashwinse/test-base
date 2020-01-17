output "user_ocids" {
  value = "${oci_identity_user.user.*.id}"
}

output "user_ui_password" {
  value = "${oci_identity_ui_password.ui_pwd.*.password}"
}

output "user_name" {
  value = "${oci_identity_user.user.*.name}"
}
