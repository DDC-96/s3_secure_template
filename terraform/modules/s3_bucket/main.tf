resource "aws_s3_bucket" "bucket_template" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy
  tags = var.bucket_tags
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket_template.id
  versioning_configuration {
    status = var.versioning_status
  }
}

# Encryption - Adding encryption at rest will secure the bucket in the event a KMS key is present when interacting with the bucket 

resource "aws_kms_key" "kmskey" {
  description             = var.kmskey_description
  enable_key_rotation     = var.kmskey_key_rotation
  rotation_period_in_days = var.kmskey_rotation_period
}

resource "aws_kms_alias" "kmsalias" {
  name          = var.aws_kms_alias
  target_key_id = aws_kms_key.kmskey.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_config" {
  bucket = aws_s3_bucket.bucket_template.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kmskey.arn
      sse_algorithm     = var.sse_algorithm
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}