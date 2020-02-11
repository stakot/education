resource "aws_db_instance" "wordpress" {
  identifier           = "wp"
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wp"
  username             = "wordpress"
  password             = "wordpress"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.rds.name}"
}