## Create ECR repository
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.repository_list)
  name     = each.key
}