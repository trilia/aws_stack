// Role for Master node
resource "aws_iam_role" "eks_master_role" {

  name = "${var.iam_master_role_name}"
 
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
 
resource "aws_iam_role_policy_attachment" "trilia-master-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_master_role.name}"
}

resource "aws_iam_role_policy_attachment" "trilia-master-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_master_role.name}"
}

// Role for worker node
resource "aws_iam_role" "eks_node_role" {

  name = "${var.iam_node_role_name}"
 
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
 
resource "aws_iam_role_policy_attachment" "trilia-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks_node_role.name}"
}
 
resource "aws_iam_role_policy_attachment" "trilia-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks_node_role.name}"
}
 
resource "aws_iam_role_policy_attachment" "trilia-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks_node_role.name}"
}
 
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.instance_profile_name}"
  role = "${aws_iam_role.eks_node_role.name}"
}