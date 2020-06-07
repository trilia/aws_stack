
data "aws_availability_zones" "availzone" {}

resource "aws_vpc" "trl_vpc" {

  cidr_block = "${var.vpc_subnet_prefix}.0.0/${var.vpc_netid_bits}"

  tags = tomap({"Name" = "${var.vpc_name}"})
}

resource "aws_subnet" "vpc_subnet" {

  count = "${var.subnet_count}"
  
  availability_zone = "${data.aws_availability_zones.availzone.names[count.index]}"
  //cidr_block        = "${var.vpc_subnet_prefix}.${format(count.index * 80)}.0/${var.vpc_subnet_netid_bits}"
  cidr_block = cidrsubnet( "${var.vpc_subnet_prefix}.0.0/${var.vpc_netid_bits}", (var.vpc_subnet_netid_bits - var.vpc_netid_bits), count.index )
  vpc_id            = "${aws_vpc.trl_vpc.id}"

  tags = tomap( { "Name" = "${var.vpc_name}-subnet-${count.index}" } )
  
}

resource "aws_security_group" "vpc_sg" {

	name        = "${var.vpc_sg_name}"
	description = "Allow inbound traffic from specific networks"
	vpc_id      = "${aws_vpc.trl_vpc.id}"
  
	dynamic "ingress" {
	
		for_each = var.vpc_sg_ingress

		content {
			//ingress {
			from_port   = ingress.value.port_from
			to_port     = ingress.value.port_to
			protocol    = ingress.value.protocol

			cidr_blocks = ingress.value.cidrs
			//}
		}
  
	}
  
	dynamic "egress" {
	
		for_each = var.vpc_sg_egress

		content {
			//ingress {
			from_port   = egress.value.port_from
			to_port     = egress.value.port_to
			protocol    = egress.value.protocol

			cidr_blocks = egress.value.cidrs
			//}
		}
	}
  
}

//TODO: Somehow the module reference below is not working ... to be fixed
//module "vpc_igwy" {

//	source = "../igwy"
	
	//should_create_igwy = var.attach_internet_gateway
//	vpc_name = "${var.vpc_name}"
//	igwy_name = "${var.vpc_name}-igwy"
	
//}


resource "aws_internet_gateway" "vpc_igwy" {

  count = var.attach_internet_gateway ? 1 : 0

  vpc_id = "${aws_vpc.trl_vpc.id}"

  tags = {
    "Name" = "${var.vpc_name}-igwy"
  }
}

resource "aws_route_table" "igwy_rt" {

	count = var.attach_internet_gateway ? 1 : 0

	vpc_id = "${aws_vpc.trl_vpc.id}"

	route {
		cidr_block = "${var.igwy_route_cidr}"
		gateway_id = "${aws_internet_gateway.vpc_igwy[0].id}"
	}
}

resource "aws_route_table_association" "rt_asscn" {

  count = var.attach_internet_gateway ? length(aws_subnet.vpc_subnet.*.id) : 0

  subnet_id      = "${aws_subnet.vpc_subnet[count.index].id}"
  route_table_id = "${aws_route_table.igwy_rt[0].id}"

}


