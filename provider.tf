terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"

    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"

    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

terraform {
  backend "s3" {
    bucket         = "macro-eyes-statefile-bucket"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "macro-eyes-lock-statefile"
  }
}


