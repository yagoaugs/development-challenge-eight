locals {
  tags = {
    Owner       = "Yago Augusto"
    Managed-by  = "terraform"
    created_by  = "terraform"
    Environment = "stage"
    Project     = "iac"
  }

  aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"

}