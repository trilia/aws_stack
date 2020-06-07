variable "region" {
  default = "ap-south-1"
}

variable "control_comp_installer" {
	default = "install_control_comps.sh"
}

variable "avail_zone" {
	default = "ap-south-1a"
}

variable "instance_name_tag" {
	default = "Trilia_Launcher"
}

variable "instance_type_code" {
	default = "t2.micro"
}

variable "ssh_public_key_name" {
	default = "trilia_ci_key"
}

variable "instance_security_group_ids" {
	type  = list(string)
}

variable "instance_subnet_id" {
	type = string
}

variable "instance_assign_public_ip" {
	type = boolean
}

variable "root_volume_type" {
	default = "gp2"
}

variable "root_volume_size" {
	default = 10
}

variable "ebs_volume_type" {
	default = "gp2"
}

variable "ebs_volume_size" {
	default = 10
}

variable "public_key_path" {
	default = "."
}

variable "public_key_ppk_file" {
	default = "trilia_ci.ppk"
}

variable "public_key_pem_file" {
	default = "trilia_ci.pem"
}

variable "access_key_file" {
	default = "access_key.txt"
}

variable "secret_key_file" {
	default = "secret_key.txt"
}

variable "admin_vpc_name" {
	default = "trl_admin_vpc"
}

variable "admin_vpc_subnet_prefix" {
	default = "192.168"
}

variable "admin_vpc_netid_bits" {
	default = "16"
}

variable "admin_subnet_netid_bits" {
	default = "26"
}

variable "admin_sec_group_name" {
	default = "trl_admin_sec_group"
}

variable "admin_sg_ingress_port_from_1" {
	default = "22"
}

variable "admin_sg_ingress_port_to_1" {
	default = "22"
}

variable "admin_sg_ingress_cidrs" {
	type    = list(string)
	//default = ["157.48.0.0/16", "103.206.0.0/16"]
	default = ["0.0.0.0/0"]
}

variable "admin_sg_ingress_port_from_2" {
	default = "443"
}

variable "admin_sg_ingress_port_to_2" {
	default = "443"
}


variable "ssh_key_private" {
	default = "D:\\Projects\\Certs_n_Keys\\trilia_trial_24Oct19.pem"
}