
resource "aws_key_pair" "trilia_ci_key" {
  key_name   = "trilia_ci_key"
  public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApM1sHfam1/hjC8Df0XA/3W5n6u8/qAzDb7VKnYda3Nfoj/63uAmKlPJ5+k5fME7/rWPZ/G2oM585BGKHnQdd11EkZHJ0xGqKGxWO38mSV/YhxyQjk3HugsJdLoKOFOdbokOwJJFlaGN4mzD8Oi9i4rH1V1K/z7muZareTLp27JxhnSeSpUIc97X2tqeW9S35O6aYA34JL9spc2Hv/myh0iHAQviVMy6uMJD8t3frhS+WCvKWnu5S/yr+gpBHrAF29fZiM0wCxfOnYB17mhHrNP7tJ1il/OjMR0wknk+IJwVnpAfwQXLG/OkNvplIOYo2GQ8lkRhPJzikaT14CQQu6w== rsa-key-20191024"
}

//resource "aws_s3_bucket" "my-s3-091230213" {
  //bucket = "my-s3-bucket-1"
//  bucket = "my-s3-091230213-1"
//  acl    = "private"
//  region = "${var.region}"
//}

resource "aws_ebs_volume" "trilia_ci_ebs_vol" {
  availability_zone = "${var.avail_zone}"
  type				= ${var.ebs_volume_type}
  size              = ${var.ebs_volume_size}

  tags = {
    Name = "${var.instance_name_tag}-volume"
  }
}

resource "aws_instance" "trilia_ci_linux_mc" {

	ami           = "ami-07c6f85a734a3da4e"
	instance_type = "${var.instance_type_code}"
	depends_on = ["aws_ebs_volume.trilia_ci_ebs_vol", "aws_key_pair.trilia_ci_key"]
	
	key_name = "${var.ssh_public_key_name}"
	//availability_zone = "${var.avail_zone}"
	//security_groups = ["${admin_sec_group_name}"]
	vpc_security_group_ids = "${var.instance_security_group_ids}"
	subnet_id = "${var.instance_subnet_id}"
	associate_public_ip_address = "${var.instance_assign_public_ip}"

	//provisioner "local-exec" {
	//	command = ()
	//}
	
	root_block_device = [{
		volume_type = "${var.root_volume_type}"
		volume_size = ${var.root_volume_size}
	}]
	
	user_data = "${file("${var.control_comp_installer}")}"
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.public_key_ppk_file}"
		destination = "/tmp/${var.public_key_ppk_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.public_key_pem_file}"
		destination = "/tmp/${var.public_key_pem_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.access_key_file}"
		destination = "/tmp/${var.access_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.secret_key_file}"
		destination = "/tmp/${var.secret_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
  
	provisioner "remote-exec" {
		inline = [
			
			"dos2unix /tmp/${var.public_key_ppk_file}; dos2unix /tmp/${var.public_key_pem_file}; dos2unix /tmp/${var.access_key_file}; dos2unix /tmp/${var.secret_key_file};"
		]
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file(var.ssh_key_private)}"
			host 		  = "${self.public_ip}"
		}
	}
   
	tags = {
		Name = "${var.instance_name_tag}"
	}
  
}


resource "aws_instance" "trilia_ci_linux_mc_native_volume" {

	ami           = "ami-07c6f85a734a3da4e"
	instance_type = "${var.instance_type_code}"
	depends_on = ["aws_ebs_volume.trilia_ci_ebs_vol", "aws_key_pair.trilia_ci_key"]
	
	key_name = "${var.ssh_public_key_name}"
	//availability_zone = "${var.avail_zone}"
	//security_groups = ["${admin_sec_group_name}"]
	vpc_security_group_ids = "${var.instance_security_group_ids}"
	subnet_id = "${var.instance_subnet_id}"
	associate_public_ip_address = "${var.instance_assign_public_ip}"

	//provisioner "local-exec" {
	//	command = ()
	//}
	
	root_block_device = [{
		volume_type = "${var.root_volume_type}"
		volume_size = ${var.root_volume_size}
	}]
	
	ebs_block_device = [{
      device_name = "/dev/sdf"
      volume_type = "${var.ebs_volume_type}"
      volume_size = ${var.ebs_volume_size}
    }]

	user_data = "${file("${var.control_comp_installer}")}"
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.public_key_ppk_file}"
		destination = "/tmp/${var.public_key_ppk_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.public_key_pem_file}"
		destination = "/tmp/${var.public_key_pem_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.access_key_file}"
		destination = "/tmp/${var.access_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
	
	provisioner "file" {
		source = "${var.public_key_path}/${var.secret_key_file}"
		destination = "/tmp/${var.secret_key_file}"

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${self.public_ip}"
		}
	}
  
	provisioner "remote-exec" {
		inline = [
			
			"dos2unix /tmp/${var.public_key_ppk_file}; dos2unix /tmp/${var.public_key_pem_file}; dos2unix /tmp/${var.access_key_file}; dos2unix /tmp/${var.secret_key_file};"
		]
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file(var.ssh_key_private)}"
			host 		  = "${self.public_ip}"
		}
	}
   
	tags = {
		Name = "${var.instance_name_tag}"
	}
  
}


resource "aws_volume_attachment" "trilia_ci_launcher_vol_attach" {
	device_name = "/dev/sdf"
	volume_id   = "${aws_ebs_volume.trilia_ci_ebs_vol.id}"
	instance_id = "${aws_instance.trilia_ci_linux_mc.id}"
}

resource "null_resource" "mount_ebs_volume" {
	
	depends_on = [aws_volume_attachment.trilia_ci_launcher_vol_attach]
	
	provisioner "remote-exec" {
		
		inline = [
		    "sudo mkdir /trilia_ci",
			"sudo chmod 755 /trilia_ci",
			"sudo mkfs -t ext4 /dev/xvdf",
			"sudo mount /dev/xvdf /trilia_ci",
			"sudo chown -R ubuntu:ubuntu /trilia_ci",
			"sudo chmod 775 /trilia_ci",
			"sudo mv /tmp/access_key.txt /trilia_ci",
			"sudo chown ubuntu:ubuntu /trilia_ci/access_key.txt",
			"sudo mv /tmp/secret_key.txt /trilia_ci",
			"sudo chown ubuntu:ubuntu /trilia_ci/secret_key.txt",
			"sudo mv /tmp/trilia_ci.ppk /trilia_ci",
			"sudo chown ubuntu:ubuntu /trilia_ci/trilia_ci.ppk",
			"sudo chmod 600 /trilia_ci/trilia_ci.ppk",
			"sudo mv /tmp/trilia_ci.pem /trilia_ci",
			"sudo chown ubuntu:ubuntu /trilia_ci/trilia_ci.pem",
			"sudo chmod 600 /trilia_ci/trilia_ci.pem",
		]

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${aws_instance.trilia_ci_linux_mc.public_ip}"
		}
	
	}

}

resource "null_resource" "unmount_ebs_volume" {
	
	depends_on = [aws_instance.trilia_ci_linux_mc]
	
	provisioner "remote-exec" {
		
		when = "destroy"
		
		inline = [
			"sudo umount -f /dev/xvdf"
		]

		connection {
		  type        = "ssh"
		  user        = "ubuntu"
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${aws_instance.trilia_ci_linux_mc.public_ip}"
		}
	
	}

}

resource "null_resource" "checkout_tf" {

	depends_on = [null_resource.mount_ebs_volume]
	
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
		  private_key = "${file(var.ssh_key_private)}"
		  host 		  = "${aws_instance.trilia_ci_linux_mc.public_ip}"
		}
	
	}
	
}



//resource "aws_eip" "my_linux_box_eip" {
//	instance = aws_instance.my_linux_box.id
//}