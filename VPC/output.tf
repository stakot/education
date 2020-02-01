output "Bastion_IP" {
  value = "${aws_instance.nat.public_ip}"
}