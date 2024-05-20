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
  value = aws_eip.eip_api_prod.public_ip
}

output "instancedb_ip_addr" {
  value = aws_eip.eip_db_prod.public_ip
}
