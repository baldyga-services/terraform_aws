provider "aws" {
  region = "us-east-1"

  access_key                  = "anaccesskey"
  secret_key                  = "asecretkey"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "static_website" {
  bucket = "static_web_bucket"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "get_object" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.get_object.json
}

data "aws_iam_policy_document" "get_object" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = "*"
    }
    actions   = "s3:GetObject"
    resources = "arn:aws:s3:::static_website/*"
  }
}