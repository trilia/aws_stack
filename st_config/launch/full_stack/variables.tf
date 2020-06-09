variable "region" {
  default = "ap-south-1"
}

variable "service_cluster_name" {
	default = "trl_svc_cluster_st_config"
}

variable "service_vpc_name" {
	default = "trl_svc_vpc"
}

variable "service_sec_group_name" {
	default = "trl_svc_sg"
}

variable "service_cluster_unique_role_suffix" {
	default = "svc_st_config"
}

variable "service_cluster_node_group_name" {
	default = "trl_svc_cluster_ng_st_config"
}

variable "db_cluster_name" {
	default = "trl_db_cluster_st_config"
}

variable "db_vpc_name" {
	default = "trl_db_vpc"
}

variable "db_sec_group_name" {
	default = "trl_db_sg"
}

variable "db_cluster_unique_role_suffix" {
	default = "db_st_config"
}

variable "db_cluster_node_group_name" {
	default = "trl_db_cluster_ng_st_config"
}
