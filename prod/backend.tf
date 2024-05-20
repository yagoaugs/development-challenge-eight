terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

  }
  backend "s3" {
    bucket = "cicd-terraform-state-bucket-devops-project-25656561"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"

  }
}
