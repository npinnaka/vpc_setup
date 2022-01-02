resource "aws_security_group" "private_sg" {
  name = "Naren-VPC-Private-Security-Group"
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.public_subnet_cidr]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.all_traffic]
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Naren-VPC-Private-Security-Group"
  }
}

resource "aws_instance" "private_instance" {
  instance_type          = "t2.micro"
  ami                    = var.ami
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    name = "Naren-VPC-Private-Instance"
  }
}