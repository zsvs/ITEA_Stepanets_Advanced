terraform {
  backend "s3" {
    bucket = "itea-adv-stepanets"           # Bucket where to SAVE Terraform State
    key    = "Lesson8-hw/terraform.tfstate" # Object name in the bucket to SAVE Terraform State
    region = "eu-west-1"                    # Region where bucket created
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}
