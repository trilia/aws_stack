

module "service_cluster" {

	source = "../../../modules/eks_cluster"

	cluster_name = "${var.service_cluster_name}"
	vpc_name = "${var.service_vpc_name}"
	sec_group_name = "${var.service_sec_group_name}"
	cluster_node_group_name = "${var.service_cluster_node_group_name}"

}