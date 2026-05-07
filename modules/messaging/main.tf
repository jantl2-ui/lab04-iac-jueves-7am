# Messaging module — SQS Queues and S3 notification
# Uses the actual bucket ARN for the SQS policy condition instead of a pattern

resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project_name}-${var.environment}-image-dlq"
  message_retention_seconds = 1209600 # 14 días

  tags = { Name = "${var.project_name}-${var.environment}-image-dlq" }
}

resource "aws_sqs_queue" "main_queue" {
  name                       = "${var.project_name}-${var.environment}-image-queue"
  visibility_timeout_seconds = 360   # 6x Lambda timeout
  message_retention_seconds  = 86400 # 1 día
  receive_wait_time_seconds  = 20    # Long polling

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  tags = { Name = "${var.project_name}-${var.environment}-image-queue" }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

  queue {
    queue_arn     = aws_sqs_queue.main_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "uploads/"
  }
}

resource "aws_sqs_queue_policy" "main_queue_policy" {
  queue_url = aws_sqs_queue.main_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowS3BucketNotification"
      Effect    = "Allow",
      Principal = { Service = "s3.amazonaws.com" },
      Action    = "sqs:SendMessage",
      Resource  = aws_sqs_queue.main_queue.arn,
      Condition = {
        ArnEquals = { "aws:SourceArn" = var.s3_bucket_arn }
      }
    }]
  })
}