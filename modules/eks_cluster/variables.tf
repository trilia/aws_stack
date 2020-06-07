variable "region" {
  default = "ap-south-1"
}

variable "vpc_name" {
	default = "trl_vpc"
}

variable "sec_group_name" {
	default = "trl_vpc_sg"
}

variable "iam_master_role_name" {
	default = "trl_eks_master"
}

variable "iam_node_role_name" {
	default = "trl_eks_node"
}

variable "instance_profile_name" {
	default = "trl_eks_node_profile"
}

variable "cluster_node_group_name" {
	default = "trl_eks_cluster_node_group"
}

variable "cluster_name" {
	default = "trl_eks_cluster"
}



