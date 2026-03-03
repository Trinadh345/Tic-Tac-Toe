terraform {
  backend "s3" {
    bucket         = "trinadh01-devops-project-2026" # Use the bucket you already created
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my_devops_bucket" {
  bucket        = "trinadh01-devops-project-2026"
  force_destroy = true
}
