
locals {
	private_key_file = join("/", ["${var.credentials_location}", "${var.ssh_key_private}"])
	public_key_file = join("/", ["${var.credentials_location}", "${var.public_key_ppk_file}"])
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
		source = "${local.public_key_file}"
		destination = "/tmp/${var.public_key_ppk_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.private_key_file)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
	
	provisioner "file" {
		source = "${local.public_key_file}"
		destination = "/tmp/${var.public_key_pem_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.private_key_file)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
	
	provisioner "file" {
		source = "${local.public_key_file}"
		destination = "/tmp/${var.access_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.private_key_file)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
	
	provisioner "file" {
		source = "${local.public_key_file}"
		destination = "/tmp/${var.secret_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.private_key_file)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${self.public_ip}" : "${self.private_ip}"
		}
	}
  
	provisioner "remote-exec" {
		inline = [
			
			"dos2unix /tmp/${var.public_key_ppk_file}; dos2unix /tmp/${var.public_key_pem_file}; dos2unix /tmp/${var.access_key_file}; dos2unix /tmp/${var.secret_key_file};"
		]
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file(local.private_key_file)}"
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
		    "sudo mkdir /trilia_ci",
			"sudo mkfs -t ext4 /dev/xvdf",
			"sudo mount /dev/xvdf /trilia_ci",
			"sudo mkdir -p /trilia_ci/creds",
			"sudo chown -R ubuntu:ubuntu /trilia_ci",
			"sudo chmod -R 775 /trilia_ci",
			"sudo mv /tmp/access_key.txt /trilia_ci/creds/",
			"sudo chown ubuntu:ubuntu /trilia_ci/creds/access_key.txt",
			"sudo mv /tmp/secret_key.txt /trilia_ci/creds/",
			"sudo chown ubuntu:ubuntu /trilia_ci/creds/secret_key.txt",
			"sudo mv /tmp/trilia_ci.ppk /trilia_ci/creds/",
			"sudo chown ubuntu:ubuntu /trilia_ci/creds/trilia_ci.ppk",
			"sudo chmod 600 /trilia_ci/creds/trilia_ci.ppk",
			"sudo mv /tmp/trilia_ci.pem /trilia_ci/creds/",
			"sudo chown ubuntu:ubuntu /trilia_ci/creds/trilia_ci.pem",
			"sudo chmod 600 /trilia_ci/creds/trilia_ci.pem",
		]

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.private_key_file)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${aws_instance.trilia_ci_linux_mc_native_volume.public_ip}" : "${aws_instance.trilia_ci_linux_mc_native_volume.private_ip}"
		}
	
	}

}


resource "null_resource" "checkout_tf" {

	depends_on = [null_resource.post_process]
	
	provisioner "remote-exec" {
		
		inline = [
		    "cd /trilia_ci",
			"git clone https://github.com/trilia/aws_stack.git",
			"cd aws_stack/prod/compact/kubeprep",
			"terraform init -input=false",
			"cd aws_stack/prod/compact/kubelaunch",
			"terraform init -input=false"
		]

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(local.private_key_file)}"
		  host 		  = var.use_public_ip_for_provisioning == true ? "${aws_instance.trilia_ci_linux_mc_native_volume.public_ip}" : "${aws_instance.trilia_ci_linux_mc_native_volume.private_ip}"
		}
	
	}
	
}

