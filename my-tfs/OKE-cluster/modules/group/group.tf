resource "oci_identity_group" "group" {
  name        = "${var.group_name}"
  description = "A group managed with terraform"
}
