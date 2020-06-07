
variable "tgwy_name" {
	default = "trl_tgwy"
}

variable "from_vpc_name" {
	type = string
}

variable "to_vpc_name" {
	type = string
}

variable "from_vpc_route_cidr" {
	type = string
	default = ""
}

variable "to_vpc_route_cidr" {
	type = string
	default = ""
}