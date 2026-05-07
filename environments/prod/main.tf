# ─────────────────────────────────────────────
# PROD Environment — Module Orchestration
# ─────────────────────────────────────────────

# Sufijo aleatorio para nombres de recursos globales (S3)
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# ─────────────────────────────────────────────
# Networking
# ─────────────────────────────────────────────

module "networking" {
  source         = "../../modules/networking"
  environment    = var.environment
  project_name   = var.project_name
  sg_vpce_sqs_id = module.security.vpce_sqs_sg_id
}

# ─────────────────────────────────────────────
# Security (IAM + Security Groups)
# ─────────────────────────────────────────────

module "security" {
  source        = "../../modules/security"
  environment   = var.environment
  project_name  = var.project_name
  vpc_id        = module.networking.vpc_id
  bucket_arn    = module.storage.bucket_arn
  sqs_queue_arn = module.messaging.main_queue_arn
}

# ─────────────────────────────────────────────
# Storage (S3)
# ─────────────────────────────────────────────

module "storage" {
  source        = "../../modules/storage"
  environment   = var.environment
  project_name  = var.project_name
  random_suffix = random_string.suffix.result
}

# ─────────────────────────────────────────────
# Messaging (SQS + S3 Notifications)
# ─────────────────────────────────────────────

module "messaging" {
  source        = "../../modules/messaging"
  environment   = var.environment
  project_name  = var.project_name
  s3_bucket_id  = module.storage.bucket_id
  s3_bucket_arn = module.storage.bucket_arn
}

# ─────────────────────────────────────────────
# Compute (Lambda Functions)
# ─────────────────────────────────────────────

module "compute" {
  source              = "../../modules/compute"
  environment         = var.environment
  project_name        = var.project_name
  upload_role_arn     = module.security.upload_role_arn
  crop_role_arn       = module.security.crop_role_arn
  private_subnet_ids  = module.networking.private_subnet_ids
  sg_upload_lambda_id = module.security.upload_sg_id
  sg_crop_lambda_id   = module.security.crop_sg_id
  s3_bucket_name      = module.storage.bucket_id
  sqs_queue_arn       = module.messaging.main_queue_arn
  memory_crop         = var.lambda_memory_crop
}

# ─────────────────────────────────────────────
# Observability (CloudWatch + SNS)
# ─────────────────────────────────────────────

module "observability" {
  source                      = "../../modules/observability"
  environment                 = var.environment
  project_name                = var.project_name
  dlq_queue_name              = module.messaging.dlq_name
  upload_lambda_function_name = module.compute.upload_lambda_function_name
  crop_lambda_function_name   = module.compute.crop_lambda_function_name
  retention_in_days           = var.log_retention_days
}

# ─────────────────────────────────────────────
# API Gateway
# ─────────────────────────────────────────────

module "api" {
  source                      = "../../modules/api_gateway"
  environment                 = var.environment
  project_name                = var.project_name
  upload_lambda_invoke_arn    = module.compute.upload_lambda_invoke_arn
  upload_lambda_function_name = module.compute.upload_lambda_function_name
  cors_allowed_origins        = var.cors_allowed_origins
  access_log_group_arn        = module.observability.apigw_log_group_arn
}