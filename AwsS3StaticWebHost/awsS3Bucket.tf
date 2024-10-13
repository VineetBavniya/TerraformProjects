resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name

}

resource "aws_s3_bucket_ownership_controls" "name" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
    bucket = aws_s3_bucket.mybucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.name,
    aws_s3_bucket_public_access_block.example,
  ]

  acl = "public-read"
}

locals {
  files_to_uploads = {
    // fileName = fileType
    "index.html" = "text/html"
    "error.html" = "text/html"
    "index.css" = "text/css"
    "logo.png" = "text/png"
    "pause.png" = "text/png"
    "play.png" = "text/png"
    "image.png" = "text/png"
    "mySong.mp3" = "text/mp3"
  }

}


resource "aws_s3_object" "object" {
  bucket   = aws_s3_bucket.mybucket.id
  for_each = local.files_to_uploads
  key      = each.key
  source   = "myWeb/${each.key}"
  acl      = "public-read"
  content_type = each.value
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket     = aws_s3_bucket.mybucket.id
  depends_on = [aws_s3_bucket_acl.example]
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}