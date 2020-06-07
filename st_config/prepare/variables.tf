variable "region" {
  default = "ap-south-1"
}

variable "admin_vpc_name" {
	default = "trl_admin_vpc"
}

variable "svc_vpc_name" {
	default = "trl_svc_vpc"
}

variable "svc_vpc_subnet_prefix" {
	default = "192.176"
}

variable "svc_vpc_sg_name" {
	default = "trl_svc_sg"
}

variable "svc_vpc_sg_ingress" {
	type = list
	default = [
		{ "port_from" : "80", "port_to" : "80", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "443", "port_to" : "443", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "0", "port_to" : "65535", "protocol" : "tcp" , "cidrs" : ["192.172.0.0/16"] }
	]
}

variable "svc_vpc_sg_egress" {
	type = list
	default = [
		{ "port_from" : "80", "port_to" : "80", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "443", "port_to" : "443", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "0", "port_to" : "65535", "protocol" : "tcp" , "cidrs" : ["192.172.0.0/16"] },
		{ "port_from" : "0", "port_to" : "65535", "protocol" : "tcp" , "cidrs" : ["192.174.0.0/18"] }
	]
}

variable "db_vpc_name" {
	default = "trl_db_vpc"
}

variable "db_vpc_subnet_prefix" {
	default = "192.174"
}

variable "db_vpc_sg_name" {
	default = "trl_db_sg"
}

variable "db_vpc_sg_ingress" {
	type = list
	default = [
		{ "port_from" : "0", "port_to" : "65535", "protocol" : "tcp" , "cidrs" : ["192.172.0.0/16"] },
		{ "port_from" : "25000", "port_to" : "32000", "protocol" : "tcp" , "cidrs" : ["192.176.0.0/16"] }
	]
}

variable "db_vpc_sg_egress" {
	type = list
	default = [
		{ "port_from" : "80", "port_to" : "80", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "443", "port_to" : "443", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "0", "port_to" : "65535", "protocol" : "tcp" , "cidrs" : ["192.172.0.0/16"] },
		{ "port_from" : "25000", "port_to" : "32000", "protocol" : "tcp" , "cidrs" : ["192.176.0.0/16"] }
	]
}

variable "admin_2_service_tgwy_name" {
	default = "trl_admin_2_svc_tgwy"
}

variable "admin_2_db_tgwy_name" {
	default = "trl_admin_2_svc_tgwy"
}

variable "service_2_db_tgwy_name" {
	default = "trl_admin_2_svc_tgwy"
}

variable "service_launcher_instance_name" {
	default = "Trilia_Svc_Launcher"
}

variable "db_launcher_instance_name" {
	default = "Trilia_DB_Launcher"
}

variable "use_public_ip_for_svc_launcher_provisioning" {
	type = bool
	default = false
}

variable "use_public_ip_for_db_launcher_provisioning" {
	type = bool
	default = false
}