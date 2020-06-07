
output "vpc_subnet_ids" {
	value = "${tolist(aws_subnet.vpc_subnet.*.id)}"
}

output "vpc_sg_id" {
	value = "${aws_security_group.vpc_sg.id}"
}

output "vpc_id" {
	value = "${aws_vpc.trl_vpc.id}"
}

output "vpc_name" {
	value = "${lookup(aws_vpc.trl_vpc.tags, "Name")}"
}