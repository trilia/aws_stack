
data "awc_vpc" "this_vpc" {
	tags = tomap({"Name" = "${var.vpc_name}"})
}

data "aws_subnet_ids" "this_vpc_subnet_ids" {
	vpc_id = "${data.aws_vpc.this_vpc.id}"
}

resource "aws_internet_gateway" "igwy" {

  count = var.should_create_igwy ? 1 : 0

  vpc_id = "${data.aws_vpc.this_vpc.id}"

  tags = {
    "Name" = "${var.igwy_name}"
  }
}

resource "aws_route_table" "igwy_rt" {

	count = var.should_create_igwy ? 1 : 0

	vpc_id = "${data.aws_vpc.this_vpc.id}"

	route {
		cidr_block = "${var.igwy_route_cidr}"
		gateway_id = "${aws_internet_gateway.igwy[0].id}"
	}
}

resource "aws_route_table_association" "rt_asscn" {

  count = var.should_create_igwy ? length(data.aws_subnet_ids.this_vpc_subnet_ids) : 0

  subnet_id      = "${data.aws_subnet_ids.this_vpc_subnet_ids[count.index]}"
  route_table_id = "${aws_route_table.igwy_rt[0].id}"

}