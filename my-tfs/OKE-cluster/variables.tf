variable "tenancy_name" {
  default = ""
}

variable "tenancy_ocid" {
  default = ""
}

variable "user_ocid" {
  default = ""
}

variable "fingerprint" {
  default = ""
}

variable "private_key_path" {
  default = ""
}

variable "ociregion" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "compartment_name" {
  default = ""
}

variable "user_count" {
  default = "1"
}

variable "group_name" {
  default = "okegroup"
}

variable "user_name_prefix" {
  default = "dytryu"
}

variable "role" {
  default = "manage"
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVokRM3IFKq28Gon3h/dl6OlhJp3E/y4iWY2/RbX2mtB+x//0UqVqk+4eaf+UawFY9fG2ccMpzJ7OnSWPhLusyNkjk0I3ioDCq8HSHjt6qxP0IdxNMGSB2Xo0Q7MqJ4pT4CqysoMKjKLM0x8CTQEhy/J2Qte4vzaKc7l9BuNT9qyTEhP/T5ggG2lPVrOV9cXvPq7zvip09hNoguFNO/XFF/Es56aZ2aF1Ulvtn82remHTBaA8ZUb2fS1SPsEwcg5fdHm864VZndPe3bL6iCDrRT/Wb9C0XK+RQIFmKz02KMHjAb3mjUhga4LtQU3LkLOjBKng8TXOh5C7g/myKn8+t Sysgain@DESKTOP-M6RUV18"
}

variable "oke" {
  type = "map"

  default = {
    name             = "okecluster"
    version          = "v1.12.7"
    shape            = "VM.Standard1.1"
    nodes_per_subnet = 1
  }
}
