provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

resource "aws_s3_bucket" "b" {
  provider = aws.west
  bucket = "project-cloud-snb-8.1"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = "project-cloud-snb-8.1"
  key    = "ikbeneenfoto.png"
  source = "foto.png"
}

resource "aws_s3_bucket_policy" "b" {
  provider = aws.west
  bucket = aws_s3_bucket.b.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::project-cloud-snb-8.1/*"
    }
  ]
}
POLICY
}
