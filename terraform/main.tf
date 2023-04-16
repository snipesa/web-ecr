provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket = "snipes-github-bucket1"
    key = "terraform.tfstate"   # created in console if file location available
    region = "us-west-1"
  }
}

resource "aws_ecr_repository" "repo1" {
  name                 = "app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}