# ─────────────────────────────────────────────
# Security Groups
# ─────────────────────────────────────────────

resource "aws_security_group" "upload_lambda" {
  name        = "${var.project_name}-${var.environment}-sg-upload-lambda"
  description = "Security group for the Upload Lambda function - allows HTTPS egress to SQS (VPC) and S3 (Gateway Endpoint)"
  vpc_id      = var.vpc_id

  # SQS Interface Endpoint lives inside the VPC CIDR
  egress {
    description = "HTTPS to SQS via Interface VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # S3 Gateway Endpoint routes via the S3 managed prefix list (public IPs, internally routed)
  egress {
    description     = "HTTPS to S3 via Gateway VPC Endpoint"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-63a5400a"] # com.amazonaws.us-east-1.s3
  }

  tags = { Name = "${var.project_name}-${var.environment}-sg-upload-lambda" }
}

resource "aws_security_group" "crop_lambda" {
  name        = "${var.project_name}-${var.environment}-sg-crop-lambda"
  description = "Security group for the Crop Lambda function - allows HTTPS egress to SQS (VPC) and S3 (Gateway Endpoint)"
  vpc_id      = var.vpc_id

  # SQS Interface Endpoint lives inside the VPC CIDR
  egress {
    description = "HTTPS to SQS via Interface VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # S3 Gateway Endpoint routes via the S3 managed prefix list (public IPs, internally routed)
  egress {
    description     = "HTTPS to S3 via Gateway VPC Endpoint"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-63a5400a"] # com.amazonaws.us-east-1.s3
  }

  tags = { Name = "${var.project_name}-${var.environment}-sg-crop-lambda" }
}

resource "aws_security_group" "vpce_sqs" {
  name        = "${var.project_name}-${var.environment}-sg-vpce-sqs"
  description = "Security group for the SQS VPC Endpoint - allows inbound HTTPS from Lambdas"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from Lambda security groups"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [
      aws_security_group.upload_lambda.id,
      aws_security_group.crop_lambda.id
    ]
  }

  tags = { Name = "${var.project_name}-${var.environment}-sg-vpce-sqs" }
}

# ─────────────────────────────────────────────
# IAM Roles
# ─────────────────────────────────────────────

resource "aws_iam_role" "upload_lambda_role" {
  name = "${var.project_name}-${var.environment}-upload-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = { Name = "${var.project_name}-${var.environment}-upload-lambda-role" }
}

resource "aws_iam_role" "crop_lambda_role" {
  name = "${var.project_name}-${var.environment}-crop-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = { Name = "${var.project_name}-${var.environment}-crop-lambda-role" }
}

# ─────────────────────────────────────────────
# IAM Policy Attachments — VPC Access
# ─────────────────────────────────────────────

resource "aws_iam_role_policy_attachment" "upload_vpc_access" {
  role       = aws_iam_role.upload_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "crop_vpc_access" {
  role       = aws_iam_role.crop_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# ─────────────────────────────────────────────
# IAM Inline Policies — Least Privilege
# ─────────────────────────────────────────────

resource "aws_iam_role_policy" "upload_s3_policy" {
  name = "${var.project_name}-${var.environment}-upload-s3-policy"
  role = aws_iam_role.upload_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:PutObject"],
      Resource = "${var.bucket_arn}/*"
    }]
  })
}

# CloudWatch Logs permissions for Upload Lambda
resource "aws_iam_role_policy" "upload_logs_policy" {
  name = "${var.project_name}-${var.environment}-upload-logs-policy"
  role = aws_iam_role.upload_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_name}-${var.environment}-*:*"
    }]
  })
}

resource "aws_iam_role_policy" "crop_s3_sqs_policy" {
  name = "${var.project_name}-${var.environment}-crop-s3-sqs-policy"
  role = aws_iam_role.crop_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "S3ReadWrite"
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = "${var.bucket_arn}/*"
      },
      {
        Sid    = "SQSConsume"
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = var.sqs_queue_arn
      }
    ]
  })
}

# CloudWatch Logs permissions for Crop Lambda
resource "aws_iam_role_policy" "crop_logs_policy" {
  name = "${var.project_name}-${var.environment}-crop-logs-policy"
  role = aws_iam_role.crop_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_name}-${var.environment}-*:*"
    }]
  })
}

# ─────────────────────────────────────────────
# Data Sources
# ─────────────────────────────────────────────

data "aws_caller_identity" "current" {}
