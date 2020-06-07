#!/bin/bash

export PATH=$PATH:/usr/bin;

result=1;

for attempt in 1 2 3 4 5;
do
        if [[ $result -eq 0 ]]
        then
                echo "All components installed successfully.";
                break;
        else
                sleep 5;
        fi

        echo "Trying to install required components, attempt $attempt";
        rm -f /var/lib/apt/lists/lock;
        rm -f /var/cache/apt/archives/lock;
        rm -f /var/lib/dpkg/lock;
		dpkg --configure -a;
        apt update -yq --fix-missing;
		if [[ $? -eq 0 ]]
        then
				apt install -y software-properties-common;
                apt install -y git;
                apt install -y docker;
                apt install -y unzip;
				
				#apt install -y python3.7;
				#update-alternatives --install /usr/bin/python python /usr/bin/python3 10;
				apt install -y python3-pip;
				#pip3 install --upgrade pip;
				
				#python3 -m pip uninstall pip;
				#apt install python3-pip --reinstall;
				
				pip3 install --upgrade --user awscli;
				pip3 uninstall -y awscli;
				chown -R ubuntu:ubuntu ~/.local
				pip3 install awscli;
				
				apt-add-repository --yes --update ppa:ansible/ansible;
				apt install -y ansible;
				
                mkdir /terraform; chmod 755 /terraform; cd /terraform;
                wget https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip;
                unzip terraform_0.12.13_linux_amd64.zip;
                rm terraform_0.12.13_linux_amd64.zip;
                ln -s /terraform/terraform /usr/bin;
				#cd /tmp;
				
                result=0;
        else
                echo "Issue with apt update .. retrying !";
        fi
done

#mkdir /aws_stack; chmod 755 aws_stack; cd aws_stack;
#terraform init -input=false;
echo "Terraform initialized in /aws_stack";
