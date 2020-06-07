
data "aws_vpc" "from_vpc" {
	
	// This is just to defer the query to apply stage. In some use
	// cases the vpc is not created yet.
	depends_on = [ "aws_ec2_transit_gateway.transit_gwy" ]

	filter {
		name   = "tag:Name"
		values = ["${var.from_vpc_name}"]
	}
}

data "aws_vpc" "to_vpc" {

	// This is just to defer the query to apply stage. In some use
	// cases the vpc is not created yet.
	depends_on = [ "aws_ec2_transit_gateway.transit_gwy" ]

	filter {
		name   = "tag:Name"
		values = ["${var.to_vpc_name}"]
	}
}

data "aws_subnet_ids" "from_vpc_subnet_ids" {

	vpc_id = "${data.aws_vpc.from_vpc.id}"
	
}

data "aws_subnet_ids" "to_vpc_subnet_ids" {

	vpc_id = "${data.aws_vpc.to_vpc.id}"
	
}

data "aws_route_table" "from_vpc_rt" {

	vpc_id = "${data.aws_vpc.from_vpc.id}"
	subnet_id = "${element(tolist(data.aws_subnet_ids.from_vpc_subnet_ids.ids), 0)}"
	
}

data "aws_route_table" "to_vpc_rt" {

	vpc_id = "${data.aws_vpc.to_vpc.id}"
	subnet_id = "${element(tolist(data.aws_subnet_ids.to_vpc_subnet_ids.ids), 0)}"

}

resource "aws_ec2_transit_gateway" "transit_gwy" {
  
  tags = tomap( {"Name" = "${var.tgwy_name}"} )
    
}

resource "aws_ec2_transit_gateway_vpc_attachment" "gwy_attach_from_vpc" {
  
  subnet_ids         = "${data.aws_subnet_ids.from_vpc_subnet_ids.ids}"
  transit_gateway_id = "${aws_ec2_transit_gateway.transit_gwy.id}"
  vpc_id             = "${data.aws_vpc.from_vpc.id}"

  tags = {
    Name = "${var.tgwy_name}-${var.from_vpc_name}-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "gwy_attach_to_vpc" {
  
  subnet_ids         = "${data.aws_subnet_ids.to_vpc_subnet_ids.ids}"
  transit_gateway_id = "${aws_ec2_transit_gateway.transit_gwy.id}"
  vpc_id             = "${data.aws_vpc.to_vpc.id}"

  tags = {
    Name = "${var.tgwy_name}-${var.to_vpc_name}-attachment"
  }
}

resource "aws_route" "tgwy_route_from_vpc" {

	depends_on = ["aws_ec2_transit_gateway_vpc_attachment.gwy_attach_from_vpc", "aws_ec2_transit_gateway_vpc_attachment.gwy_attach_to_vpc"]

	route_table_id = "${data.aws_route_table.from_vpc_rt.id}"
	destination_cidr_block = coalesce( "${var.to_vpc_route_cidr}", "${data.aws_vpc.to_vpc.cidr_block}" )
	//destination_cidr_block = "${data.aws_vpc.to_vpc.cidr_block}"
    transit_gateway_id = "${aws_ec2_transit_gateway.transit_gwy.id}"
	
}

resource "aws_route" "tgwy_route_to_vpc" {

	depends_on = ["aws_ec2_transit_gateway_vpc_attachment.gwy_attach_from_vpc", "aws_ec2_transit_gateway_vpc_attachment.gwy_attach_to_vpc"]

	route_table_id = "${data.aws_route_table.to_vpc_rt.id}"
	destination_cidr_block = coalesce( "${var.from_vpc_route_cidr}", "${data.aws_vpc.from_vpc.cidr_block}" )
	//destination_cidr_block = "${data.aws_vpc.from_vpc.cidr_block}"
    transit_gateway_id = "${aws_ec2_transit_gateway.transit_gwy.id}"
	
}