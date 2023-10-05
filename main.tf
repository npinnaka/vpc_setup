resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "key_pair" {
  public_key = tls_private_key.private_key.public_key_openssh
  key_name   = "narenkp"
  tags = {
    Name = "VPC-KeyPair"
  }
}

resource "local_file" "key" {
  filename = "./narenkp.pem"
  content  = tls_private_key.private_key.private_key_pem
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC"
  }
}



