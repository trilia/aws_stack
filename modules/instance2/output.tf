
output "instance_public_ip" {
  value = "${aws_instance.trilia_ci_linux_mc.*.public_ip}"
}

output "instance_private_ip" {
  value = "${aws_instance.trilia_ci_linux_mc.*.private_ip}"
}