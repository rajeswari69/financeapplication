terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
    region = "ap-south-1"
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
