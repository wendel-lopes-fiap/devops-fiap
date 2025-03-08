terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0.0"
    }
  }

  backend "s3" {
    bucket = "s3-wendel-save-terraform-states"
    key    = "dev.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}
