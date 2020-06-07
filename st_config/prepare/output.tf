
output "service_launcher_mc_pub_ip" {
  value = "${module.svc_launcher_mc.instance_public_ip}"
}

output "service_launcher_mc_pvt_ip" {
  value = "${module.svc_launcher_mc.instance_private_ip}"
}

output "db_launcher_mc_pub_ip" {
  value = "${module.db_launcher_mc.instance_public_ip}"
}

output "db_launcher_mc_pvt_ip" {
  value = "${module.db_launcher_mc.instance_private_ip}"
}