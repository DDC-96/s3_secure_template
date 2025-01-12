module "s3_bucket" {
  source = "../../modules/s3_bucket"
  bucket_name = "devops-bucket199723"
  bucket_tags = {
    "Data Classification" = "Financial Data"
    "Data Owner" = "CFO" 
  }
}

