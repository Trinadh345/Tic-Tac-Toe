terraform {
  backend "s3" {
    bucket         = "trinadh01-devops-project-2026"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}
