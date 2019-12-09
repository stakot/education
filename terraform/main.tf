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
  security_groups = ["${aws_security_group.ssh.name}","${aws_security_group.jenkins.name}"]
  key_name   = "hillel2"
  
  root_block_device {
  delete_on_termination = true
  }
  tags = {
    Name = "HelloWorld"
  }
   provisioner "remote-exec" {
    inline = [
      "sudo setenforce Permissive",
      "sudo echo '${file("/home/sko/edu/terraform/templates_nginx_repo.tmpl")}' >> ~/nginx.repo",
      "sudo cp ~/nginx.repo /etc/yum.repos.d/nginx.repo",
      "sudo yum -y install nginx",
      "sudo yum install -y wget",
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm", 
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum -y install  java-1.8.0-openjdk.x86_64",
      "sudo yum -y install jenkins",
      "sudo service jenkins start",     
#     "sudo echo '${file("/home/sko/edu/terraform/template_nginx_config.tmpl")}' >> ~/jenkins.conf",
#     "sudo cp ~/jenkins.conf /etc/nginx/conf.d/jenkins.conf",
      "sudo rm /etc/nginx/conf.d/default.conf"
    ]
    }
    provisioner "file" {
    content = "${templatefile("/home/sko/edu/terraform/template_nginx_config.tmpl", {server_name = "${self.public_ip}"})}"
    destination = "/tmp/jenkins.conf"
  }
    provisioner "remote-exec" {
      inline = [
        "sudo cp /tmp/jenkins.conf /etc/nginx/jenkins.conf",
        "sudo service jenkins start"
      ]
    }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("/home/sko/Documents/hillel2.pem")}"
    host = "${element(aws_instance.web.*.public_ip, 0)}"
  }
}