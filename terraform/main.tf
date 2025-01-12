resource "aws_s3_bucket" "bucket_template" {
  bucket = "bucket_template_devops"
  tags = {
    Name        = "OPsec Bucket"
    Environment = "Test"
  }
}


resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket_template.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption - Adding encryption at rest will secure the bucket in the event a KMS key is present when interacting with the bucket 

resource "aws_kms_key" "kmskey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  rotation_period_in_days = 90
}

resource "aws_kms_alias" "kmsalias" {
  name          = "alias/s3-kms-alias"
  target_key_id = aws_kms_key.kmskey.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_config" {
  bucket = aws_s3_bucket.bucket_template.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kmskey.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}