resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = "ami-04cf43aca3e6f3de3" 
  instance_type = "t2.micro"
  key_name   = "hillel2"

  security_groups = ["${aws_security_group.asg.id}"]
  associate_public_ip_address = true

  user_data = <<USER_DATA
#!/bin/bash
yum update
yum -y install nginx  
chkconfig nginx on
service nginx start
  USER_DATA

  lifecycle {
    create_before_destroy = true
  }
}

