resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "public_eu_central_1a" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Public Subnet eu-central-1a"
  }
}

resource "aws_subnet" "public_eu_central_1b" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Public Subnet eu-central-1b"
  }
}

resource "aws_subnet" "private_eu_central_1a" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  availability_zone = "eu-central-1a"
  cidr_block = "10.0.3.0/24"
  

  tags = {
    Name = "Private Subnet eu-central-1a"
  }
}
resource "aws_subnet" "private_eu_central_1b" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  availability_zone = "eu-central-1b"
  cidr_block = "10.0.4.0/24"
  

  tags = {
    Name = "Private Subnet eu-central-1b"
  }
}

resource "aws_db_subnet_group" "rds" {
  name        = "rds_subnet_group"
  subnet_ids  = ["${aws_subnet.private_eu_central_1a.id}", "${aws_subnet.private_eu_central_1b.id}"]
   
  tags = {
    Name = "Subnet group for RDS"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_public" {
    vpc_id = "${aws_vpc.my_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my_vpc_igw.id}"
    }

    tags = {
        Name = "Route Table for My VPC"
    }
}

resource "aws_route_table_association" "my_vpc_eu_central_1a_public" {
    subnet_id = "${aws_subnet.public_eu_central_1a.id}"
    route_table_id = "${aws_route_table.my_vpc_public.id}"
}

resource "aws_route_table_association" "my_vpc_eu_central_1b_public" {
    subnet_id = "${aws_subnet.public_eu_central_1b.id}"
    route_table_id = "${aws_route_table.my_vpc_public.id}"
}

resource "aws_route_table_association" "my_vpc_eu_central_1a_private" {
    subnet_id = "${aws_subnet.private_eu_central_1a.id}"
    route_table_id = "${aws_route_table.my_vpc_public.id}"
}

resource "aws_route_table_association" "my_vpc_eu_central_1b_private" {
    subnet_id = "${aws_subnet.private_eu_central_1b.id}"
    route_table_id = "${aws_route_table.my_vpc_public.id}"
}

resource "aws_instance" "nat" {
    ami = "ami-06a5303d47fbd8c60" # this is a special ami preconfigured to do Bastion
    availability_zone = "eu-central-1a"
    instance_type = "t2.micro"
    key_name = "hillel2"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    subnet_id = "${aws_subnet.private_eu_central_1a.id}"
    associate_public_ip_address = true
    source_dest_check = false
    
    root_block_device {
    delete_on_termination = true
 }
    tags = {
        Name = "VPC Bastion"
    }
    connection {    
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("/home/sko/Documents/hillel2.pem")}"
    host = "${element(aws_instance.web.*.public_ip, 0)}"
  }
}

/* resource "aws_eip" "nat" {
	instance = "${aws_instance.nat.id}"
	vpc = true
} */