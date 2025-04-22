resource "aws_db_instance" "postgres" {
  identifier              = "${local.project_name}-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = [aws_security_group.rds-sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  db_name                 = var.db_name

  tags = {
    Name = "${local.project_name}-postgres"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${local.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = "db-subnet-group"
  }
}