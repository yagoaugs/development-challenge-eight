output "aws_vpc" {
  description = "ID of VPC"
  value       = aws_vpc.vpc_terraform
}

output "aws_subnet_public_1a" {
  description = "ID of VPC"
  value       = aws_subnet.public_subnet_1a
}

output "aws_subnet_private_1a" {
  description = "ID of VPC"
  value       = aws_subnet.private_subnet_1a
}

output "instance_ip_addr" {
  value = aws_eip.eip_api_stage.public_ip
}

output "instancedb_ip_addr" {
  value = aws_eip.eip_db_stage.public_ip
}

output "repository_url" {
  value = aws_ecr_repository.repository
}

output "private_key_pem" {
  value = tls_private_key.my_key.private_key_pem
  sensitive = true
}

output "public_key_pem" {
  value = tls_private_key.my_key.public_key_pem
}