variable "environment" {
  description = "El entorno de despliegue (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
  default     = "image-processor"
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
  description = "ARN de la cola SQS principal para el trigger de crop-lambda"
  type        = string
}

variable "memory_upload" {
  description = "Memoria en MB asignada a la Lambda de Upload"
  type        = number
  default     = 256

  validation {
    condition     = var.memory_upload >= 128 && var.memory_upload <= 10240
    error_message = "memory_upload debe estar entre 128 y 10240 MB."
  }
}

variable "memory_crop" {
  description = "Memoria en MB asignada a la Lambda de Crop (procesamiento de imagen)"
  type        = number
  default     = 512

  validation {
    condition     = var.memory_crop >= 128 && var.memory_crop <= 10240
    error_message = "memory_crop debe estar entre 128 y 10240 MB."
  }
}

variable "timeout_upload" {
  description = "Timeout en segundos para la Lambda de Upload"
  type        = number
  default     = 30

  validation {
    condition     = var.timeout_upload >= 1 && var.timeout_upload <= 900
    error_message = "timeout_upload debe estar entre 1 y 900 segundos."
  }
}

variable "timeout_crop" {
  description = "Timeout en segundos para la Lambda de Crop"
  type        = number
  default     = 60

  validation {
    condition     = var.timeout_crop >= 1 && var.timeout_crop <= 900
    error_message = "timeout_crop debe estar entre 1 y 900 segundos."
  }
}