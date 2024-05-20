resource "aws_instance" "db_prod" {
  ami                         = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.my_key_pair_prod.key_name
  subnet_id                   = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids      = [aws_security_group.sg_dmz.id, aws_security_group.sg_integrations.id, aws_security_group.sg_developers.id]
  associate_public_ip_address = true
  user_data                   = file("./vm-db.sh")
  iam_instance_profile        = aws_iam_instance_profile.db_prod_instance_profile.name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    "Name" = "db-prod"
  }
}

resource "aws_eip" "eip_db_prod" {
  instance = aws_instance.db_prod.id
  domain   = "vpc"
}

resource "aws_iam_role" "db_instance_role_prod" {
  name = "db_instance_role_prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy_prod_additional" {
  role       = aws_iam_role.db_instance_role_prod.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "db_prod_instance_profile" {
  name = "db_prod_instance_profile"
  role = aws_iam_role.db_instance_role_prod.name
}
