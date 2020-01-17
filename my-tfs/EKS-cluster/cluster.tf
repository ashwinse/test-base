


// ========================== EKS=========================================

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "eks-node${random_id.unique_string.hex}",
      "kubernetes.io/cluster/${var.cluster_name}${random_id.unique_string.hex}", "shared",
    )
  }"
}

resource "aws_subnet" "eks_subnets" {
  count = 2

  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "10.0.${count.index}.0/24"
  vpc_id                  = "${aws_vpc.eks_vpc.id}"
  map_public_ip_on_launch = "true"
  tags = "${
    map(
      "Name", "eks-node${random_id.unique_string.hex}",
      "kubernetes.io/cluster/${var.cluster_name}${random_id.unique_string.hex}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = "${aws_vpc.eks_vpc.id}"

  tags = {
    Name = "eks-cluster"
  }
}

resource "aws_route_table" "eks_routetable" {
  vpc_id = "${aws_vpc.eks_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks_igw.id}"
  }
}

resource "aws_route_table_association" "rt_asstn" {
  count = 2

  subnet_id      = "${aws_subnet.eks_subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks_routetable.id}"
}

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster${random_id.unique_string.hex}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_role.name}"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_role.name}"
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

resource "aws_security_group" "cluster_sg" {
  name        = "eks-cluster${random_id.unique_string.hex}"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster"
  }
}

resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cluster_sg.id}"
  to_port           = 443
  type              = "ingress"
}
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}${random_id.unique_string.hex}"
  role_arn = "${aws_iam_role.eks_role.arn}"
  version  = "${var.cluster_version}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster_sg.id}"]
    subnet_ids         = "${aws_subnet.eks_subnets.*.id}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy",
  ]
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node${random_id.unique_string.hex}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks_node_role.name}"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks_node_role.name}"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks_node_role.name}"
}

resource "aws_iam_instance_profile" "eks_node_profile" {
  name = "eks-node${random_id.unique_string.hex}"
  role = "${aws_iam_role.eks_node_role.name}"
}

resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node${random_id.unique_string.hex}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.eks_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
      "Name", "eks-node",
      "kubernetes.io/cluster/${var.cluster_name}${random_id.unique_string.hex}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "eks_node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks_node_sg.id}"
  source_security_group_id = "${aws_security_group.eks_node_sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_node_sg.id}"
  source_security_group_id = "${aws_security_group.cluster_sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster_sg.id}"
  source_security_group_id = "${aws_security_group.eks_node_sg.id}"
  to_port                  = 443
  type                     = "ingress"
}

// data "aws_ami" "eks-worker" {
//   filter {
//     name   = "name"
//     values = ["amazon-eks-node-${var.cluster_version}-v*"]
//   }

//   most_recent = true
//   owners      = ["${data.aws_caller_identity.current.account_id}"]
// }

data "aws_region" "current" {}

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluster.certificate_authority.0.data}' '${aws_eks_cluster.eks_cluster.name}'
USERDATA
}


resource "aws_launch_configuration" "node_launch" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks_node_profile.name}"
  image_id                    = "${var.ami_id[var.region]}"
  instance_type               = "t3.small"
  name_prefix                 = "eks-nodes"
  security_groups             = ["${aws_security_group.eks_node_sg.id}"]
  user_data_base64            = "${base64encode(local.eks-node-userdata)}"


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "node_auto_scaling" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.node_launch.id}"
  max_size             = 2
  min_size             = 1
  name                 = "eks-nodes${random_id.unique_string.hex}"
  vpc_zone_identifier  = "${aws_subnet.eks_subnets.*.id}"

  tag {
    key                 = "Name"
    value               = "eks-nodes"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}${random_id.unique_string.hex}"
    value               = "owned"
    propagate_at_launch = true
  }
}

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks_node_role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    mapUsers: | 
    - userarn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/system/${aws_iam_user.tl_user.name}
      username: ${aws_iam_user.tl_user.name}
      groups: 
        - system:masters

CONFIGMAPAWSAUTH
}
resource "null_resource" "cm_authfile1" {
  depends_on = [aws_autoscaling_group.node_auto_scaling]
  provisioner "local-exec" {
    command = "bash auth-cm.sh ${aws_iam_role.eks_node_role.arn}"
  }
}

resource "null_resource" "cm_authfile2" {
  depends_on = [null_resource.cm_authfile1]
  provisioner "local-exec" {
    command = "bash auth-cm-user.sh ${aws_iam_role.eks_node_role.arn} ${data.aws_caller_identity.current.account_id} ${aws_iam_user.tl_user.name}"
  }
}


resource "null_resource" "cm_authfile3" {
  depends_on = [null_resource.cm_authfile2]
  provisioner "local-exec" {
    command = "bash auth-rbac-user.sh ${aws_iam_user.tl_user.name}"
  }
}

resource "null_resource" "cluster_access" {
  depends_on = [null_resource.cm_authfile3]
  provisioner "local-exec" {
    command = "aws configure set aws_access_key_id ${var.access_key} && aws configure set aws_secret_access_key ${var.secret_key} && aws configure set default.region ${var.region} && aws --region ${var.region} eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name} && kubectl apply -f /home/auth-cm.yaml && kubectl get nodes && kubectl apply -f /home/auth-cm-user.yaml && kubectl get nodes && kubectl apply -f /home/auth-rbac-user.yaml"
  }
}