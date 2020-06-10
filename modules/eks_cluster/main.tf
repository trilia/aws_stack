data "aws_region" "region" {}

data "aws_availability_zones" "availzone" {}

data "aws_vpc" "this_vpc" {
	filter {
		name   = "tag:Name"
		values = ["${var.vpc_name}"]
	}
}

data "aws_security_group" "vpc_sg" {

	name = "${var.sec_group_name}"
	vpc_id = "${data.aws_vpc.this_vpc.id}"
	
}

data "aws_subnet_ids" "vpc_subnet_ids" {

	vpc_id = "${data.aws_vpc.this_vpc.id}"
	
}

data "aws_ami" "eks_worker" {

  filter {
    name   = "name"
    values = ["ubuntu-eks/k8s_1.14/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20191113"] // ["amazon-eks-node-1.11-v*"]
  }
 
  most_recent = true
  owners      = ["099720109477"] # Amazon EKS AMI Account ID
  
}

resource "aws_cloudwatch_log_group" "cluster_log_group" {
  name              = "/${var.cluster_name}/cluster"
  retention_in_days = 3
}

resource "aws_eks_cluster" "this_cluster" {

  name            = "${var.cluster_name}"
  role_arn        = "${aws_iam_role.eks_master_role.arn}"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
 
  vpc_config {
    security_group_ids = ["${data.aws_security_group.vpc_sg.id}"]
    subnet_ids         = "${data.aws_subnet_ids.vpc_subnet_ids.ids}"
  }
 
  depends_on = [
    "aws_iam_role_policy_attachment.trilia-master-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.trilia-master-AmazonEKSServicePolicy",
    "aws_cloudwatch_log_group.cluster_log_group"
  ]
  
}

resource "aws_iam_openid_connect_provider" "cluster_openid_connect_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = "${aws_eks_cluster.this_cluster.identity.0.oidc.0.issuer}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster_openid_connect_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = ["${aws_iam_openid_connect_provider.cluster_openid_connect_provider.arn}"]
      type        = "Federated"
    }
  }
}

resource "aws_eks_node_group" "cluster_node_group" {

  cluster_name    = "${aws_eks_cluster.this_cluster.name}"
  node_group_name = "${var.cluster_node_group_name}"
  node_role_arn   = "${aws_iam_role.eks_node_role.arn}"
  subnet_ids      = "${data.aws_subnet_ids.vpc_subnet_ids.ids}"
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = var.cluster_desired_size
    max_size     = var.cluster_max_size
    min_size     = var.cluster_min_size
  }
  
  remote_access {
	ec2_ssh_key = "trilia_ci_key"
	source_security_group_ids = ["${data.aws_security_group.vpc_sg.id}"]
  }
  
  tags = "${
    map(
      "kubernetes.io/cluster/${var.cluster_name}", "owned",
      "k8s.io/cluster/${var.cluster_name}", "owned",
    )
  }"

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.trilia-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.trilia-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.trilia-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

