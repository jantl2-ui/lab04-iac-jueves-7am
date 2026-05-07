variable "environment" {
  description = "El entorno de despliegue (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "sg_vpce_sqs_id" {
  description = "ID del Security Group para el VPC Endpoint de SQS"
  type        = string
  default     = null
}