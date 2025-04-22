resource "aws_instance" "bastion" {
  ami                    = "ami-0eb302fcc77c2f8bd" # Amazon Linux 2023 (ap-northeast-2)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name               = var.key_pair_name
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    db_username          = var.db_username
    db_password          = var.db_password
    db_name              = var.db_name
    rds_endpoint         = aws_db_instance.postgres.address
  })
  depends_on = [
    aws_db_instance.postgres,
    aws_subnet.public_a,
    aws_internet_gateway.igw
  ]
  tags = {
    Name = "${local.project_name}-bastion"
  }
}