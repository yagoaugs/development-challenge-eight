resource "aws_instance" "api_stage" {
  ami                         = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.my_key_pair.key_name
  subnet_id                   = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids      = [aws_security_group.sg_dmz.id, aws_security_group.sg_integrations.id, aws_security_group.sg_developers.id]
  associate_public_ip_address = true
  user_data                   = file("./vm-api.sh")
  iam_instance_profile        = aws_iam_instance_profile.api_instance_profile.name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    "Name" = "api-stage"
  }
}

resource "aws_eip" "eip_api_stage" {
  instance = aws_instance.api_stage.id
  domain   = "vpc"
}

resource "aws_iam_role" "api_instance_role" {
  name = "api_instance_role"

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

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.api_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "api_instance_profile" {
  name = "api_instance_profile"
  role = aws_iam_role.api_instance_role.name
}
