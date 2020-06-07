
variable "should_create_igwy" {
	type = bool
	default = true
}

variable "vpc_name" {
	default = "trl_vpc"
}

variable "igwy_name" {
	default = "trl_vpc_igwy"
}

variable "igwy_route_cidr" {
	default = "0.0.0.0/0"
}