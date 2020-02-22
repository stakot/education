output "ELB_IP" {
  value = "${aws_elb.web_elb.dns_name}"
}

output "DB_ip" {
    value = "${aws_db_instance.wordpress.address}"
}

output "bastion_ip" {
    value = "${aws_instance.nat.public_ip}"
}

resource  "local_file" "bastion" {
  content = templatefile("${path.module}/tf_templates/ansible.cfg.tpl", {
    bastion_ip = aws_instance.nat.public_ip
  })
  filename = "./ansible/ansible.cfg"
}

resource  "local_file" "db" {
  content = templatefile("${path.module}/tf_templates/all.tpl", {
    db_dns = aws_db_instance.wordpress.address
  })
  filename = "./ansible/group_vars/all"
}
#