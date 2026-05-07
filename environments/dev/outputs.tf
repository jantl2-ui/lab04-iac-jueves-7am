output "api_gateway_url" {
  description = "URL base del API Gateway HTTP v2"
  value       = module.api.api_endpoint
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3 de imágenes"
  value       = module.storage.bucket_id
}

output "sqs_queue_url" {
  description = "URL de la cola SQS principal"
  value       = module.messaging.main_queue_url
}

output "upload_lambda_name" {
  description = "Nombre de la función Lambda de Upload"
  value       = module.compute.upload_lambda_function_name
}

output "crop_lambda_name" {
  description = "Nombre de la función Lambda de Crop"
  value       = module.compute.crop_lambda_function_name
}

output "sns_alerts_topic_arn" {
  description = "ARN del tema SNS para alertas de operación"
  value       = module.observability.sns_topic_arn
}

output "vpc_id" {
  description = "ID de la VPC del entorno"
  value       = module.networking.vpc_id
}