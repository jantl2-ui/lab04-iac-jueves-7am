output "bucket_id" {
  description = "El nombre (ID) del bucket S3"
  value       = aws_s3_bucket.images.id
}

output "bucket_arn" {
  description = "El ARN del bucket S3"
  value       = aws_s3_bucket.images.arn
}