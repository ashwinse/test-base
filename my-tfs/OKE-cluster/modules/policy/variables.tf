variable "group_name" {
  description = "Name of the user group"
}

variable "compartment_ocid" {
  description = "OCID of the compartment"
}

variable "compartment_name" {
  description = "Name of the compartment"
}

variable "role" {
  description = "Role in the policy statement it can be read, manage, inspect, "
}

variable "tenancy_ocid" {
  description = "OCID of the Tenant"
}
