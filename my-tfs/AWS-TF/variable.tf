variable "region" {
  default = "us-east-2"
}
variable "accesskey" {
  default = ""
}
variable "secretkey" {
  default = ""
}
variable "ami" {
  type = "map"
  default = {
    us-east-1 = "ami-00a208c7cdba991ea"
    us-east-2 = "ami-0270f291a8a0f0d6b"
  }
}
variable "instance_tags"{
  type = "list"
  default = ["terraform-1", "terraform-2", "terraform-3"]
}

variable "instance_count" {
  default = 1
}


