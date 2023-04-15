provider "aws" {
  region = "us-west-1"
}

resource "aws_ecr_repository" "repo1" {
  name                 = "app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}