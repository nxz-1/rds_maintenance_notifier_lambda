# RDS Instance
resource "aws_db_instance" "my_db" {
  identifier              = "wordpress-db"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  db_name                 = "wordpress"
  username                = "admin"
  password                = "Admin199830"
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.my_db_sg.id]
  backup_retention_period = 7
  multi_az                = false
  skip_final_snapshot      = true
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.my_subnet1.id, aws_subnet.my_subnet2.id]

  tags = {
    Name = "my-db-subnet-group"
  }
}
