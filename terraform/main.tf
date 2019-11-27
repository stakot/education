data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.hillel.name}"]
  key_name   = "hillel2"
  
  root_block_device {
  delete_on_termination = true
  }
  tags = {
    Name = "HelloWorld"
  }
   provisioner "remote-exec" {
 
  inline = [
      "sudo yum update -y"
    ]
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("/home/sko/Documents/hillel2.pem")}"
    host = "${element(aws_instance.web.*.public_ip, 0)}"
  }
}
    
}