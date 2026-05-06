resource "aws_security_group" "upload_lambda" {
  name   = "sg-upload-lambda-${var.environment}"
  vpc_id = var.vpc_id
  
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }
}

resource "aws_security_group" "crop_lambda" {
  name   = "sg-crop-lambda-${var.environment}"
  vpc_id = var.vpc_id
  
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }
}

resource "aws_security_group" "vpce_sqs" {
  name   = "sg-vpce-sqs-${var.environment}"
  vpc_id = var.vpc_id
  
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [
      aws_security_group.upload_lambda.id, 
      aws_security_group.crop_lambda.id
    ]
  }
}

resource "aws_iam_role" "upload_lambda_role" {
  name = "upload-lambda-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role" "crop_lambda_role" {
  name = "crop-lambda-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "upload_vpc_access" {
  role       = aws_iam_role.upload_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "crop_vpc_access" {
  role       = aws_iam_role.crop_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "upload_s3_policy" {
  name   = "UploadLambdaS3Policy"
  role   = aws_iam_role.upload_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:PutObject"],
      Resource = "arn:aws:s3:::${var.project_name}-${var.environment}-images-*/*"
    }]
  })
}

resource "aws_iam_role_policy" "crop_s3_sqs_policy" {
  name   = "CropLambdaS3SQSPolicy"
  role   = aws_iam_role.crop_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = "arn:aws:s3:::${var.project_name}-${var.environment}-images-*/*"
      },
      {
        Effect   = "Allow",
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
        Resource = "*" 
      }
    ]
  })
}
