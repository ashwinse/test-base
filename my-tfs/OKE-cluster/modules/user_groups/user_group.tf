resource "oci_identity_user" "user" {
  name        = "${var.user_name_prefix}"
  description = "User managed with Terraform"
}

resource "oci_identity_ui_password" "ui_pwd" {
  user_id = "${oci_identity_user.user.id}"
}

resource "oci_identity_user_group_membership" "t" {
  compartment_id = "${var.compartment_ocid}"
  user_id        = "${oci_identity_user.user.id}"
  group_id       = "${var.group_ocid}"
}
