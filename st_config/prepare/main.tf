
data "aws_vpc" "admin_vpc" {
	filter {
		name   = "tag:Name"
		values = ["${var.admin_vpc_name}"]
	}
	//tags = tomap({"Name" = "${var.admin_vpc_name}"})
}

module "service_vpc" {
	
	source = "../../modules/vpc"
	
	vpc_subnet_prefix = "${var.svc_vpc_subnet_prefix}"
	vpc_name = "${var.svc_vpc_name}"
	vpc_sg_name = "${var.svc_vpc_sg_name}"
	attach_internet_gateway = true

}

module "db_vpc" {
	
	source = "../../modules/vpc"
	
	vpc_subnet_prefix = "${var.db_vpc_subnet_prefix}"
	vpc_name = "${var.db_vpc_name}"
	vpc_sg_name = "${var.db_vpc_sg_name}"
	attach_internet_gateway = true
}

module "admin_2_svc_tgwy" {

	source = "../../modules/transit_gwy"

	tgwy_name = "${var.admin_2_service_tgwy_name}"
	from_vpc_name = "${var.admin_vpc_name}"
	// we must use module reference to create dependency between this module
	// and the service_vpc module. Otherwise the sequence will not be maintained
	to_vpc_name = "${module.service_vpc.vpc_name}" 

}

module "admin_2_db_tgwy" {

	source = "../../modules/transit_gwy"

	tgwy_name = "${var.admin_2_db_tgwy_name}"
	from_vpc_name = "${var.admin_vpc_name}"
	// we must use module reference to create dependency between this module
	// and the db_vpc module. Otherwise the sequence will not be maintained
	to_vpc_name = "${module.db_vpc.vpc_name}"

}

module "service_2_db_tgwy" {

	source = "../../modules/transit_gwy"

	tgwy_name = "${var.service_2_db_tgwy_name}"
	from_vpc_name = "${module.service_vpc.vpc_name}"
	// we must use module reference to create dependency between this module
	// and the db_vpc module. Otherwise the sequence will not be maintained
	to_vpc_name = "${module.db_vpc.vpc_name}"

}

module "svc_launcher_mc" {

    source = "../../modules/instance1"

	instance_name_tag = "${var.service_launcher_instance_name}"
	instance_security_group_ids = ["${module.service_vpc.vpc_sg_id}"]
	instance_subnet_id = "${module.service_vpc.vpc_subnet_ids[0]}"
	//use_public_ip_for_provisioning = var.use_public_ip_for_svc_launcher_provisioning
	
}

module "db_launcher_mc" {

    source = "../../modules/instance1"

	instance_name_tag = "${var.db_launcher_instance_name}"
	instance_security_group_ids = ["${module.db_vpc.vpc_sg_id}"]
	instance_subnet_id = "${module.db_vpc.vpc_subnet_ids[0]}"
	//use_public_ip_for_provisioning = use_public_ip_for_db_launcher_provisioning

}


