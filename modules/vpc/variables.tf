variable "region" {
  default = "ap-south-1"
}

variable "avail_zone" {
	default = "ap-south-1a"
}

variable "vpc_name" {
	default = "trl_vpc"
}

variable "subnet_count" {
	type = number
	default = 3
}

variable "vpc_subnet_prefix" {
	default = "192.168"
}

variable "vpc_netid_bits" {
	type = number
	default = 16
}

variable "vpc_subnet_netid_bits" {
	type = number
	default = 18
}

variable "vpc_sg_name" {
	default = "trl_vpc_sec_group"
}

variable "vpc_sg_ingress" {
	// By default open only http , https ports
	type = list
	default = [
		{ "port_from" : "80", "port_to" : "80", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "443", "port_to" : "443", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] }
	]
}

variable "vpc_sg_egress" {
	type = list
	default = [
		{ "port_from" : "80", "port_to" : "80", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] },
		{ "port_from" : "443", "port_to" : "443", "protocol" : "tcp" , "cidrs" : ["0.0.0.0/0"] }
	]
}

variable "attach_internet_gateway" {
	type = bool
	default = false
}

variable igwy_route_cidr {
	default = "0.0.0.0/0"
}


