resource "aws_lambda_function" "upload" {
  function_name = "upload-lambda-${var.environment}" 
  runtime       = "nodejs20.x"                       
  handler       = "index.handler"                    
  memory_size   = 256                                
  timeout       = 30                                
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
  filename        = data.archive_file.upload_zip.output_path
  source_code_hash = data.archive_file.upload_zip.output_base64sha256
}

resource "aws_lambda_function" "crop" {
  function_name = "crop-lambda-${var.environment}"   
  runtime       = "nodejs20.x"                       
  handler       = "index.handler"                    
  memory_size   = 512                               
  timeout       = 60                                 
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
  filename        = data.archive_file.crop_zip.output_path
  source_code_hash = data.archive_file.crop_zip.output_base64sha256
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn                   = var.sqs_queue_arn
  function_name                      = aws_lambda_function.crop.arn
  batch_size                         = 5              
  function_response_types            = ["ReportBatchItemFailures"] 
}

data "archive_file" "upload_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/upload-lambda"
  output_path = "${path.module}/../../src/upload-lambda.zip"
}

data "archive_file" "crop_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/crop-lambda"
  output_path = "${path.module}/../../src/crop-lambda.zip"
}