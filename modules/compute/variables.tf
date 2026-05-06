variable "environment" {
  description = "El entorno de despliegue"
  type        = string
}

variable "upload_role_arn" {
  description = "ARN del rol IAM para upload-lambda"
  type        = string
}

variable "crop_role_arn" {
  description = "ARN del rol IAM para crop-lambda"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subredes privadas para desplegar las Lambdas"
  type        = list(string)
}

variable "sg_upload_lambda_id" {
  description = "Security Group ID para upload-lambda"
  type        = string
}

variable "sg_crop_lambda_id" {
  description = "Security Group ID para crop-lambda"
  type        = string
}

variable "s3_bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN de la cola SQS principal para el trigger"
  type        = string
}

variable "memory_crop_override" {
  description = "Memoria dinámica asignada a la Lambda de Crop según el entorno"
  type        = number
}