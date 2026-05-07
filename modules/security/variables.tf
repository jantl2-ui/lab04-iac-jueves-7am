variable "environment" {
  description = "El entorno de despliegue (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC donde se crearán los Security Groups"
  type        = string
}

variable "bucket_arn" {
  description = "ARN del bucket S3 para las políticas IAM de least privilege"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN de la cola SQS principal para restringir permisos de la crop Lambda"
  type        = string
}