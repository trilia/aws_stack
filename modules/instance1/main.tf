
locals {

	//source_creds_path = join("/", ["${var.ci_source_base_location}", "${var.source_credentials_location}"])
	source_creds_path = "${var.source_credentials_location}"
	target_creds_path = join("/", ["${var.ci_target_base_location}", "${var.target_credentials_location}"])

	source_private_key_file_path = join("/", ["${local.source_creds_path}", "${var.ssh_key_private}"])
	
	source_private_key_ppk_file_path = join("/", ["${local.source_creds_path}", "${var.private_key_ppk_file}"])
	source_private_key_pem_file_path = join("/", ["${local.source_creds_path}", "${var.private_key_pem_file}"])
	
	source_access_key_file_path = join("/", ["${local.source_creds_path}", "${var.access_key_file}"])
	source_secret_key_file_path = join("/", ["${local.source_creds_path}", "${var.secret_key_file}"])
	
}

resource "aws_instance" "trilia_ci_linux_mc_native_volume" {

	ami           = "ami-07c6f85a734a3da4e"
	instance_type = "${var.instance_type_code}"
	//depends_on = ["aws_key_pair.trilia_ci_key"]
	
	key_name = "${var.ssh_public_key_name}"
	//availability_zone = "${var.avail_zone}"
	//security_groups = ["${admin_sec_group_name}"]
	vpc_security_group_ids = "${var.instance_security_group_ids}"
	subnet_id = "${var.instance_subnet_id}"
	associate_public_ip_address = "${var.instance_assign_public_ip}"

	//provisioner "local-exec" {
	//	command = ()
	//}
	
	root_block_device {
		volume_type = "${var.root_volume_type}"
		volume_size = "${var.root_volume_size}"
	}
	
	ebs_block_device {
      device_name = "/dev/sdf"
      volume_type = "${var.ebs_volume_type}"
      volume_size = "${var.ebs_volume_size}"
    }

	user_data = "${file("${path.module}/${var.control_comp_installer}")}"
	
	provisioner "file" {
		source = "${local.source_private_key_ppk_file_path}"
		destination = "/tmp/${var.private_key_ppk_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.source_private_key_file_path)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
	
	provisioner "file" {
		source = "${local.source_private_key_pem_file_path}"
		destination = "/tmp/${var.private_key_pem_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.source_private_key_file_path)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
	
	provisioner "file" {
		source = "${local.source_access_key_file_path}"
		destination = "/tmp/${var.access_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.source_private_key_file_path)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
	
	provisioner "file" {
		source = "${local.source_secret_key_file_path}"
		destination = "/tmp/${var.secret_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.source_private_key_file_path)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
  
	provisioner "remote-exec" {
		inline = [
			
			"dos2unix /tmp/${var.private_key_ppk_file}; dos2unix /tmp/${var.private_key_pem_file}; dos2unix /tmp/${var.access_key_file}; dos2unix /tmp/${var.secret_key_file};"
		]
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file(local.source_private_key_file_path)}"
			host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
   
	tags = {
		Name = "${var.instance_name_tag}"
	}
  
}


resource "null_resource" "post_process" {
	
	depends_on = [aws_instance.trilia_ci_linux_mc_native_volume]
	
	provisioner "remote-exec" {
		
		inline = [
		    "sudo mkdir ${var.ci_target_base_location}",
			"sudo mkfs -t ext4 /dev/xvdf",
			"sudo mount /dev/xvdf ${var.ci_target_base_location}",
			"sudo mkdir -p ${local.target_creds_path}",
			"sudo chown -R ubuntu:ubuntu ${var.ci_target_base_location}",
			"sudo chmod -R 775 ${var.ci_target_base_location}",
			"sudo mv /tmp/${var.access_key_file} ${local.target_creds_path}",
			"sudo chown ubuntu:ubuntu ${local.target_creds_path}/${var.access_key_file}",
			"sudo mv /tmp/${var.secret_key_file} ${local.target_creds_path}",
			"sudo chown ubuntu:ubuntu ${local.target_creds_path}/${var.secret_key_file}",
			"sudo mv /tmp/${var.private_key_ppk_file} ${local.target_creds_path}",
			"sudo chown ubuntu:ubuntu ${local.target_creds_path}/${var.private_key_ppk_file}",
			"sudo chmod 600 ${local.target_creds_path}/${var.private_key_ppk_file}",
			"sudo mv /tmp/${var.private_key_pem_file} ${local.target_creds_path}",
			"sudo chown ubuntu:ubuntu ${local.target_creds_path}/${var.private_key_pem_file}",
			"sudo chmod 600 ${local.target_creds_path}/${var.private_key_pem_file}",
		]

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.source_private_key_file_path)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${aws_instance.trilia_ci_linux_mc_native_volume.public_ip}" : "${aws_instance.trilia_ci_linux_mc_native_volume.private_ip}"
		}
	
	}

}


resource "null_resource" "checkout_tf" {

	depends_on = [null_resource.post_process]
	
	provisioner "remote-exec" {
		
		inline = [
		    "cd ${var.ci_target_base_location}",
			"git clone https://github.com/trilia/aws_stack.git",
			"cd aws_stack/prod/compact/kubeprep",
			"terraform init -input=false",
			"cd aws_stack/prod/compact/kubelaunch",
			"terraform init -input=false"
		]

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.source_private_key_file_path)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${aws_instance.trilia_ci_linux_mc_native_volume.public_ip}" : "${aws_instance.trilia_ci_linux_mc_native_volume.private_ip}"
		}
	
	}
	
}

