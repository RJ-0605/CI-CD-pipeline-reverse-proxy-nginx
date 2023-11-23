
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  
}


terraform {
  backend "s3"{
    bucket = "rod-ted-search-bucket"
    key = "rodneytedsearch/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "rod-ted-search-dynamo-db"
  }
}


provider "aws" {
    region     = "us-west-2"
   
}



resource "aws_iam_instance_profile" "my_profile"{
    name = "rodney-instance-profile-dv-${terraform.workspace}-v-ch-k"
    role = data.aws_iam_role.my_new.name
}


resource "aws_instance" "aws_ec2"{
    ami = var.aws_instances[0].ami
    instance_type = var.aws_instances[0].instance_type
    key_name = var.key_pair_ssh
    iam_instance_profile = aws_iam_instance_profile.my_profile.name

    associate_public_ip_address = var.assoc_public_ip_ids
    subnet_id = data.aws_subnet.my_subs.id
    vpc_security_group_ids = [data.aws_security_group.my_scgrp.id]

    tags = {
        Name = "rodney-td-search-ec2-${terraform.workspace}"
        Owner = var.user_tags.Owner
        bootcamp = var.user_tags.bootcamp
        expiration_date = var.user_tags.expiration_date

    }

}


resource "null_resource" "web_instance"{
    # Copies the file as the root user using SSH

connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("/var/jenkins_home/workspace/rod-Toxic-Task-jenk-gitlab.pem")}"
    host     = aws_instance.aws_ec2.public_ip
  }

provisioner "local-exec"{
    command = "echo ${aws_instance.aws_ec2.public_ip} > ip_test.txt "
  }

provisioner "local-exec"{
  command = " mkdir ted_search_bstrp && cp -r docker-compose.yaml config-app ted_search_bstrp &&  zip -r ted_search_bstrp.zip ted_search_bstrp "
}

  
provisioner "file" {
    source      = "ted_search_bstrp.zip"
    destination = "/home/ubuntu/ted_search_bstrp.zip"
  }


provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

provisioner "remote-exec" {
    inline = [
      "sudo apt install unzip", 
      "unzip ted_search_bstrp.zip -d /home/ubuntu/ ",
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

}

