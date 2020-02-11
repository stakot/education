/*
  Bastion host
*/

resource "aws_security_group" "ssh" {
    name = "vpc_ssh"
    description = "Allow incoming SSH connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${aws_vpc.default.id}"

    tags ={
        Name = "BastionServerSG"
    }
}

/* 
resource "aws_instance" "web-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "eu-central-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
    subnet_id = "${aws_subnet.eu-central-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags ={
        Name = "Web Server 1"
    }
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.web-1.id}"
    vpc = true
}
*/

