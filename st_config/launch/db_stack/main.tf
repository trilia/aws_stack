

module "db_cluster" {

	source = "../../../modules/eks_cluster"

	cluster_name = "${var.db_cluster_name}"
	vpc_name = "${var.db_vpc_name}"
	sec_group_name = "${var.db_sec_group_name}"
	cluster_node_group_name = "${var.db_cluster_node_group_name}"

}