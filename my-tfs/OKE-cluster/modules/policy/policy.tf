resource "oci_identity_policy" "p" {
  name           = "${var.group_name}-policy"
  description    = "automated terraform users policy"
  compartment_id = "${var.compartment_ocid}"

  statements = [
    "Allow group ${var.group_name} to ${var.role} instance-family in compartment ${var.compartment_name}",
    "Allow group ${var.group_name} to ${var.role} virtual-network-family in compartment ${var.compartment_name}",
    "Allow group ${var.group_name} to ${var.role} volume-family in compartment ${var.compartment_name}",
  ]
}

resource "oci_identity_policy" "p2" {
  name           = "${var.group_name}-policy"
  description    = "OKE cluster manage policy"
  compartment_id = "${var.tenancy_ocid}"

  statements = [
    "allow group ${var.group_name} to ${var.role} cluster-family in tenancy",
  ]
}
