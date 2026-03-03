# my-sql database
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "fintech_db"
  username             = "admin"
  password             = "Password123" # రియల్ టైమ్‌లో దీనిని సీక్రెట్ గా ఉంచాలి
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  db_subnet_group_name   = aws_db_subnet_group.db_sub_group.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]

  tags = {
    Name = "FinTech-Production-DB"
  }
}

# db subnet-group
resource "aws_db_subnet_group" "db_sub_group" {
  name       = "fintech-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnets[4].id, aws_subnet.private_subnets[5].id]

  tags = {
    Name = "FinTech-DB-Subnet-Group"
  }
}
