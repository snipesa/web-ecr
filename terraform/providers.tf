provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    region = "us-west-1"
    #dynamodb_table = "terraform.tfstate.lock"    # helps log your state file to dynamodb. created in console. therefore secure your statefile. this is such that multiple users cant make changess to your file at thesame
  }
}


