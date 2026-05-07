# ─────────────────────────────────────────────
# S3 Bucket
# ─────────────────────────────────────────────

resource "aws_s3_bucket" "images" {
  bucket = "${var.project_name}-${var.environment}-images-${var.random_suffix}"

  tags = { Name = "${var.project_name}-${var.environment}-images" }
}

# ─────────────────────────────────────────────
# Seguridad S3
# ─────────────────────────────────────────────

resource "aws_s3_bucket_public_access_block" "images_block" {
  bucket = aws_s3_bucket.images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "images_sse" {
  bucket = aws_s3_bucket.images.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ─────────────────────────────────────────────
# Versionado
# ─────────────────────────────────────────────

resource "aws_s3_bucket_versioning" "images_versioning" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ─────────────────────────────────────────────
# Lifecycle Rules
# ─────────────────────────────────────────────

resource "aws_s3_bucket_lifecycle_configuration" "images_lifecycle" {
  bucket = aws_s3_bucket.images.id

  rule {
    id     = "expire_uploads"
    status = "Enabled"
    filter { prefix = "uploads/" }
    expiration { days = 30 }
    noncurrent_version_expiration { noncurrent_days = 7 }
  }

  rule {
    id     = "expire_processed"
    status = "Enabled"
    filter { prefix = "processed/" }
    expiration { days = 90 }
    noncurrent_version_expiration { noncurrent_days = 14 }
  }
}