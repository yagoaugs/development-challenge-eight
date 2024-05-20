resource "aws_vpc" "vpc_terraform" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "vpc-stage"
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc_terraform.id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1b"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.vpc_terraform.id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-1b"
  }
}

resource "aws_internet_gateway" "internet_gateway_iac" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "internet-gateway-iac"
  }
}

resource "aws_route_table" "route_table_public_iac" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_iac.id
  }

  tags = {
    Name = "route-table-public-iac"
  }
}

resource "aws_route_table_association" "rta_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.route_table_public_iac.id
}

resource "aws_route_table_association" "rta_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.route_table_public_iac.id
}


resource "aws_security_group" "sg_dmz" {
  name        = "api_stage"
  description = "Allows Default Traffic"
  vpc_id      = aws_vpc.vpc_terraform.id

  ingress {
    description      = "Allows HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allows HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Allows Zabbix Server"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["52.206.23.96/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_security_group" "sg_integrations" {
  name        = "integrations"
  description = "Allows Integrations Services"
  vpc_id      = aws_vpc.vpc_terraform.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "34.199.54.113/32",
      "34.232.25.90/32",
      "34.232.119.183/32",
      "34.236.25.177/32",
      "35.171.175.212/32",
      "52.54.90.98/32",
      "52.202.195.162/32",
      "52.203.14.55/32",
      "52.204.96.37/32",
      "34.218.156.209/32",
      "34.218.168.212/32",
      "52.41.219.63/32",
      "35.155.178.254/32",
      "35.160.177.10/32",
      "34.216.18.129/32",
      "3.216.235.48/32",
      "34.231.96.243/32",
      "44.199.3.254/32",
      "174.129.205.191/32",
      "44.199.127.226/32",
      "44.199.45.64/32",
      "3.221.151.112/32",
      "52.205.184.192/32",
      "52.72.137.240/32",
    ]
  }
  tags = local.tags
}

resource "aws_security_group" "sg_developers" {
  name        = "developers"
  description = "Allow Access for Developres Team"
  vpc_id      = aws_vpc.vpc_terraform.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["177.220.179.1/32"]
    description = "yago.augusto"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}