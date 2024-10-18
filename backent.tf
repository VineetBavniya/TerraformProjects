// create s3 inside aws and also dynammodb after put here details
terraform {
  backend "db" {
    bucket = ""
    key = ""
    region = "us-east-1"
    dynamodb = ""
  }
}

