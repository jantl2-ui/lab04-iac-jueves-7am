resource "aws_s3_bucket" "images" {
  bucket = "${var.project_name}-${var.environment}-images-${var.random_suffix}" 
}

resource "aws_s3_bucket_server_side_encryption_configuration" "images_sse" {
  bucket = aws_s3_bucket.images.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } } 
}

resource "aws_s3_bucket_versioning" "images_versioning" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration { status = "Enabled" } 
}

resource "aws_s3_bucket_lifecycle_configuration" "images_lifecycle" {
  bucket = aws_s3_bucket.images.id
  rule {
    id     = "expire_uploads"
    status = "Enabled"
    filter { prefix = "uploads/" } 
    expiration { days = 30 }       
  }
  rule {
    id     = "expire_processed"
    status = "Enabled"
    filter { prefix = "processed/" } 
    expiration { days = 90 }         
  }
}