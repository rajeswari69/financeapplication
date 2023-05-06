terraform {
  backend "remote" {
    organization = "hashicorp-v2"

    workspaces {
      name = "terraform-provider-aws-repository"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.24.0"
    }
  }

  required_version = ">= 0.13.5"
}

provider "github" {
  owner = "hashicrop"
}
resource "aws_instance" "ec2_server" {
   ami = "ami-02eb7a4783e7e9317"
   instance_type = "t2.micro"
   key_name = "mykey"
   vpc_security_group_ids = ["sg-0078d46d0981fea1c"]
   provisioner "remote-exec" {
      inline = ["echo 'waituntil ssh is ready'"]
      connection {
           type = "ssh"
           user = "ubuntu"
           private_key = file("mykey.pem")
           host = aws_instance.ec2_server.public_ip
      }
   }
   tags = {
     Name = "terraform_server"
   }
   provisioner "local-exec" {
        command = "echo ${aws_server.ec2_server.public_ip} > inventory"
   }
}
