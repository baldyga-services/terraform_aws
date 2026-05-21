terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check = true

  s3_use_path_style = true

  endpoints {
    iam = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "AppServer"
  }
}
