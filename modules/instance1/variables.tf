
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
	type = bool
	default = true
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

variable "use_public_ip_for_provisioning" {
	type = bool
	default = false
}

variable "credentials_location" {
	default = "/trilia_ci/creds"
}

variable "ssh_key_private" {
	default = "trilia_ci.pem"
}