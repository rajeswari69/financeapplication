
provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAXPH3XV36SCC2XOMI"
    secret_key = "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"
}
resource "aws_instance" "ec2-server" {
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
           host = aws_instance.ec2-server.public_ip
      }
   }
   tags = {
     Name = "terraform-server"
   }
   provisioner "local-exec" {
        command = "echo ${aws_instance.ec2-server.public_ip} > inventory"
   }
}
