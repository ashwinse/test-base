output "accountid" {
  value = [
    "${data.aws_caller_identity.current.account_id}"
  ]
}

output "username" {
  value = ["${aws_iam_user.tl_user.name}"]
  
}

output "password" {
  value = ["${var.username}@${random_id.password.hex}"]
  
}

output "clusterregion" {
  value = ["${var.region}"]
}
output "clustername" {
  value = ["${aws_eks_cluster.eks_cluster.name}"]
}

output "clusterendpoint" {
  value = ["${aws_eks_cluster.eks_cluster.endpoint}"]
}


output "region" {
  value = ["${var.location[var.region]}"]
}


output "accesssecret" {
  value = ["${aws_iam_access_key.access_key.secret}"]
}


output "accesskeyid" {
  value = ["${aws_iam_access_key.access_key.id}"]
}



