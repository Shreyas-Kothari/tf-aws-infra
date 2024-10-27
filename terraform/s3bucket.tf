resource "random_uuid" "shreyas_tf_s3_name" {}

resource "aws_s3_bucket" "shreyas_tf_s3_bucket" {
  bucket        = "csye6225-${random_uuid.shreyas_tf_s3_name.result}"
  force_destroy = true
  tags = {
    Name        = "CSYE6225 Cloud Storage Bucket"
    Description = "This is a bucket for CSYE 6225 course for saving the user proflie images"
  }
}

// S3 Bucket public access Configuration to blck public access
resource "aws_s3_bucket_public_access_block" "shreyas_tf_bucket_access" {
  bucket                  = aws_s3_bucket.shreyas_tf_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 Bucket Server Side Encryption Configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "shreyas_tf_s3_encryption" {
  bucket = aws_s3_bucket.shreyas_tf_s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "shreyas_tf_s3_lifecycle" {
  bucket = aws_s3_bucket.shreyas_tf_s3_bucket.id
  rule {
    id     = "TransitionToStandardIA"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}