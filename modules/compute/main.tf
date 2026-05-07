# ─────────────────────────────────────────────
# Compute Module — Lambda Functions
# ─────────────────────────────────────────────

# Upload Lambda — Receives images via API Gateway and stores in S3
resource "aws_lambda_function" "upload" {
  function_name = "${var.project_name}-${var.environment}-upload-lambda"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  memory_size   = var.memory_upload
  timeout       = var.timeout_upload
  role          = var.upload_role_arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.sg_upload_lambda_id]
  }

  environment {
    variables = {
      S3_BUCKET     = var.s3_bucket_name
      UPLOAD_PREFIX = "uploads/"
    }
  }

  filename         = data.archive_file.upload_zip.output_path
  source_code_hash = data.archive_file.upload_zip.output_base64sha256

  tags = { Name = "${var.project_name}-${var.environment}-upload-lambda" }
}

# Crop Lambda — Processes images from SQS, creates circular 40x40 thumbnails
resource "aws_lambda_function" "crop" {
  function_name = "${var.project_name}-${var.environment}-crop-lambda"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  memory_size   = var.memory_crop
  timeout       = var.timeout_crop
  role          = var.crop_role_arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.sg_crop_lambda_id]
  }

  environment {
    variables = {
      S3_BUCKET        = var.s3_bucket_name
      PROCESSED_PREFIX = "processed/"
    }
  }

  filename         = data.archive_file.crop_zip.output_path
  source_code_hash = data.archive_file.crop_zip.output_base64sha256

  tags = { Name = "${var.project_name}-${var.environment}-crop-lambda" }
}

# ─────────────────────────────────────────────
# SQS → Crop Lambda Trigger
# ─────────────────────────────────────────────

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn        = var.sqs_queue_arn
  function_name           = aws_lambda_function.crop.arn
  batch_size              = 5
  function_response_types = ["ReportBatchItemFailures"]
}

# ─────────────────────────────────────────────
# Lambda Deployment Packages
# ─────────────────────────────────────────────

data "archive_file" "upload_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/upload-lambda"
  output_path = "${path.module}/../../build/upload-lambda.zip"
  excludes    = ["node_modules/.cache", "node_modules/.bin", "*.zip"]
}

data "archive_file" "crop_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/crop-lambda"
  output_path = "${path.module}/../../build/crop-lambda.zip"
  excludes    = ["node_modules/.cache", "node_modules/.bin", "*.zip"]
}