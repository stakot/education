/*
  Backend Servers
*/
resource "aws_security_group" "back" {
    name = "vpc_db"
    description = "Allow incoming database connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }


    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "BACKBServerSG"
    }
}

resource "aws_instance" "back-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "eu-central-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.back.id}"]
    subnet_id = "${aws_subnet.eu-central-1a-private.id}"
    source_dest_check = false

    tags ={
        Name = "Backend Server 1"
    }
}