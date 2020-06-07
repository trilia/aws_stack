
resource "aws_key_pair" "trilia_ci_key" {
  	key_name   = "trilia_ci_key_new"
  	public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApM1sHfam1/hjC8Df0XA/3W5n6u8/qAzDb7VKnYda3Nfoj/63uAmKlPJ5+k5fME7/rWPZ/G2oM585BGKHnQdd11EkZHJ0xGqKGxWO38mSV/YhxyQjk3HugsJdLoKOFOdbokOwJJFlaGN4mzD8Oi9i4rH1V1K/z7muZareTLp27JxhnSeSpUIc97X2tqeW9S35O6aYA34JL9spc2Hv/myh0iHAQviVMy6uMJD8t3frhS+WCvKWnu5S/yr+gpBHrAF29fZiM0wCxfOnYB17mhHrNP7tJ1il/OjMR0wknk+IJwVnpAfwQXLG/OkNvplIOYo2GQ8lkRhPJzikaT14CQQu6w== rsa-key-20191024"
}

module "admin_vpc" {
	
	source = "../modules/vpc"
	
	vpc_subnet_prefix = "${var.admin_vpc_subnet_prefix}"
	vpc_name = "${var.admin_vpc_name}"
	vpc_sg_name = "${var.admin_sg_name}"
	vpc_sg_ingress = "${var.admin_vpc_sg_ingress}"
	vpc_sg_egress = "${var.admin_vpc_sg_egress}"
	attach_internet_gateway = true
	
}

module "launcher_mc" {

    source = "../modules/instance1"

	instance_name_tag = "${var.admin_instance_name}"
	instance_security_group_ids = ["${module.admin_vpc.vpc_sg_id}"]
	instance_subnet_id = "${module.admin_vpc.vpc_subnet_ids[0]}"
	credentials_location = "${var.my_credentials_location}"
	use_public_ip_for_provisioning = true
	
}
