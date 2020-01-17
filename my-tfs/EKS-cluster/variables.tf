variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = ""
}

variable "location" {
  description = "Respected location with the region"
  type        = "map"

  default = {
    us-east-1      = "US East (N. Virginia)"
    us-east-2      = "US East (Ohio)"
    us-west-1      = "US West (N. California)"
    us-west-2      = "US West (Oregon)"
    ap-east-1      = "Asia Pacific (Hong Kong)"
    ap-south-1     = "Asia Pacific (Mumbai)"
    ap-northeast-3 = "Asia Pacific (Osaka-Local)"
    ap-northeast-2 = "Asia Pacific (Seoul)"
    ap-southeast-1 = "Asia Pacific (Singapore)"
    ap-southeast-2 = "Asia Pacific (Sydney)"
    ap-northeast-1 = "Asia Pacific (Tokyo)"
    ca-central-1   = "Canada (Central)"
    cn-north-1     = "China (Beijing)"
    cn-northwest-1 = "China (Ningxia)"
    eu-central-1   = "EU (Frankfurt)"
    eu-west-1      = "EU (Ireland)"
    eu-west-2      = "EU (London)"
    eu-west-3      = "EU (Paris)"
    eu-north-1     = "EU (Stockholm)"
    me-south-1     = "Middle East (Bahrain)"
    sa-east-1      = "South America (São Paulo)"
    us-gov-east-1  = "AWS GovCloud (US-East)"
    us-gov-west-1  = "AWS GovCloud (US-West)"
  }
}

variable "group_name" {
  description = "name for the group"
  default     = "tl_users_group"
}

variable "policy_name" {
  description = "name for the policy"
  default     = "tl_users_policy"
}

variable "role_name" {
  description = "name for the policy"
  default     = "tl_users_role"
}

variable "username" {
  description = "Desired name for the IAM user"
  default     = "qldtluser"
}

variable "group_membership_name" {
  default = "tl_users_membership"
}

// ================== EKS variables ==============================

variable "cluster_name" {
  default = "eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = "string"
  default     = "1.13"
}

variable "ami_id" {
  description = "Respected location with the region"
  type        = "map"

  default = {
    us-east-1      = "ami-08198f90fe8bc57f0"
    us-east-2      = "ami-0355b5edf93d47112"
    us-west-2      = "ami-0dc5bf48daa40eb35"
    ap-south-1     = "ami-00f4cff050d28ee2d"
    ap-northeast-2 = "ami-0d9a543e7c4279c11"
    ap-southeast-1 = "ami-0013f4890e2ce167b"
    ap-southeast-2 = "ami-01cd15b342b7edf5e"
    ap-northeast-1 = "ami-0262013b4d50142a2"
    eu-central-1   = "ami-01ffee931e45bb6bf"
    eu-west-1      = "ami-00ea6211202297fe8"
    eu-west-2      = "ami-0ef7099142dae7023"
    eu-west-3      = "ami-00cc28b5bcb9dc724"
    eu-north-1     = "ami-01d7a7c38f882ef68"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = "map"
  default     = {}
}
