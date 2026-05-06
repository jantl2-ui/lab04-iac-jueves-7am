# Invocación de los módulos locales
module "networking" {
  source       = "../../modules/networking"
  environment  = var.environment
  project_name = var.project_name
  # En un entorno real, aquí pasarías el ID del Security Group de los Endpoints
  # sg_vpce_sqs_id = module.security.vpce_sqs_sg_id 
}

module "security" {
  source       = "../../modules/security"
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

module "storage" {
  source        = "../../modules/storage"
  environment   = var.environment
  project_name  = var.project_name
  random_suffix = "xyz123" # Típicamente generado con un recurso random_string
}

module "messaging" {
  source       = "../../modules/messaging"
  environment  = var.environment
  project_name = var.project_name
  s3_bucket_id = module.storage.bucket_id
}

module "compute" {
  source              = "../../modules/compute"
  environment         = var.environment
  upload_role_arn     = module.security.upload_role_arn
  crop_role_arn       = module.security.crop_role_arn
  private_subnet_ids  = module.networking.private_subnet_ids
  sg_upload_lambda_id = module.security.upload_sg_id
  sg_crop_lambda_id   = module.security.crop_sg_id
  s3_bucket_name      = module.storage.bucket_id
  sqs_queue_arn       = module.messaging.main_queue_arn
  memory_crop_override = var.lambda_memory_crop
}

module "api" {
  source                   = "../../modules/api"
  environment              = var.environment
  project_name             = var.project_name
  upload_lambda_invoke_arn = module.compute.upload_lambda_invoke_arn
}

module "observability" {
  source             = "../../modules/observability"
  environment        = var.environment
  project_name       = var.project_name
  dlq_queue_name     = module.messaging.dlq_name
  sns_topic_arn      = "arn:aws:sns:us-east-1:123456789012:alert-topic" # Reemplazar por un SNS real
  retention_in_days  = var.log_retention_days
}