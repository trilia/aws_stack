
module "service_cluster" {

	source = "../../../modules/eks_cluster"

	cluster_name = "${var.service_cluster_name}"
	vpc_name = "${var.service_vpc_name}"
	sec_group_name = "${var.service_sec_group_name}"
	unique_role_suffix = "${var.service_cluster_unique_role_suffix}"
	cluster_node_group_name = "${var.service_cluster_node_group_name}"

}


module "db_cluster" {

	source = "../../../modules/eks_cluster"

	cluster_name = "${var.db_cluster_name}"
	vpc_name = "${var.db_vpc_name}"
	sec_group_name = "${var.db_sec_group_name}"
	unique_role_suffix = "${var.db_cluster_unique_role_suffix}"
	cluster_node_group_name = "${var.db_cluster_node_group_name}"

}