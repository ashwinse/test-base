provider "aws" {
  version    = "~> 2.0"
  access_key = "${var.accesskey}"
  secret_key = "${var.secretkey}"
  region     = "${var.region}"
}
