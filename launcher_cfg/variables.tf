variable "region" {
  default = "ap-south-1"
}

#variable "avail_zone" {
#	default = "ap-south-1a"
#}

variable "admin_vpc_name" {
  default = "trl_admin_vpc"
}

variable "admin_vpc_subnet_prefix" {
  default = "192.172"
}

variable "admin_sg_name" {
  default = "trl_admin_sg"
}

variable "admin_vpc_sg_ingress" {
	type = list
	default = [
		{ "port_from" : "22", "port_to" : "22", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] }
	]
}

variable "admin_vpc_sg_egress" {
	type = list
	default = [
		{ "port_from" : "0", "port_to" : "65535", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] }
	]
}

variable "admin_instance_name" {
  default = "Trilia_Launcher"
}

variable "my_credentials_location" {
	default = "../creds"
}
